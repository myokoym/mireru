require "gtk3"
require "gio2"

module Mireru
  class Navigator < Gtk::ScrolledWindow
    PATH_COLUMN, FILENAME_COLUMN, ICON_COLUMN = 0, 1, 2

    def initialize(window, files)
      super()
      @window = window
      @files = files
      @dir_iters = {}
      set_policy(:automatic, :automatic)
      set_size_request(200, -1)
      @model = Gtk::TreeStore.new(String, String, Gdk::Pixbuf)
      @tree_view = create_tree(@model)
      add(@tree_view)
    end

    def next
      @tree_view.move_cursor(Gtk::MovementStep::DISPLAY_LINES, 1)
    end

    def prev
      @tree_view.move_cursor(Gtk::MovementStep::DISPLAY_LINES, -1)
    end

    def expand_toggle(open_all=false)
      path = selected_path
      iter = @model.get_iter(path)
      file_path = iter.get_value(PATH_COLUMN)
      if open_all and File.file?(file_path)
        parent = iter.parent
        path = @model.get_path(parent)
        @tree_view.collapse_row(path)
      elsif @tree_view.row_expanded?(path)
        @tree_view.collapse_row(path)
      else
        if open_all
          return unless File.directory?(file_path)
          Dir.glob("#{file_path}/*") do |dir|
            next unless File.directory?(dir)
            child_iter = @dir_iters[dir]
            next unless child_iter
            load_dir(@model, dir, child_iter, true)
            @dir_iters.delete(dir)
          end
        end
        @tree_view.expand_row(path, open_all)
      end
    end

    def selected_path
      selection = @tree_view.selection
      selected = selection.selected
      @model.get_path(selected)
    end

    private
    def create_tree(model)
      tree_view = Gtk::TreeView.new
      tree_view.set_model(model)
      tree_view.search_column = FILENAME_COLUMN
      tree_view.enable_search = false

      selection = tree_view.selection
      selection.set_mode(:browse)

      @files.each do |file|
        load_file(model, file)
      end

      column = Gtk::TreeViewColumn.new
      if @files.size == 1
        column.title = File.dirname(@files.first)
      else
        column.title = "Selected Files"
      end
      tree_view.append_column(column)

      renderer = Gtk::CellRendererPixbuf.new
      renderer.set_fixed_size(*Gtk::IconSize.lookup(:menu))
      column.pack_start(renderer, :expand => false)
      column.add_attribute(renderer, :pixbuf, ICON_COLUMN)

      renderer = Gtk::CellRendererText.new
      column.pack_start(renderer, :expand => false)
      column.add_attribute(renderer, :text, FILENAME_COLUMN)

      selection.signal_connect("changed") do |selection|
        apply_changed(selection)
      end

      tree_view.expand_all
      tree_view
    end

    def apply_changed(selection)
      iter = selection.selected
      return unless iter
      path = iter.get_value(PATH_COLUMN)
      if File.directory?(path)
        if @dir_iters[path]
          load_dir(@model, path, @dir_iters[path])
        end
        @dir_iters.delete(path)
      end
      return unless File.file?(path)
      @window.title = path
      @window.file = path
      begin
        GLib::Timeout.add(100) do
          if @window.file == path
            begin
              @window.add_from_file(path)
            rescue => e
              $stderr.puts("#{e.class}: #{e.message}")
              $stderr.puts(e.backtrace)
            end
          end
          false
        end
      rescue
        stock = Gtk::Stock::MISSING_IMAGE
        size = :dialog
        pixbuf = Gtk::Image.new.render_icon_pixbuf(stock, size)
      end
    end

    def load_dir(model, dir, parent=nil, recursive=false)
      Dir.glob("#{File.expand_path(dir)}/*") do |child|
        load_file(model, child, parent, recursive)
      end
    end

    def load_file(model, file, parent=nil, recursive=false)
      iter = model.append(parent)
      iter.set_value(PATH_COLUMN, file)
      iter.set_value(FILENAME_COLUMN, File.basename(file))
      if File.directory?(file)
        @dir_iters[file] = iter unless recursive
        dir_icon = self.render_icon_pixbuf(Gtk::Stock::DIRECTORY, :menu)
        iter.set_value(ICON_COLUMN, dir_icon)
        load_dir(model, file, iter, recursive) if recursive
      else
        file_icon = select_icon(file)
        iter.set_value(ICON_COLUMN, file_icon)
      end
      # TODO: too slow...
      #icon_width, icon_height = Gtk::IconSize.lookup(:menu)
      #begin
      #  pixbuf = Gdk::Pixbuf.new(file_path, icon_width, icon_height)
      #rescue Gdk::PixbufError
      #  pixbuf = file_icon
      #end
      #iter.set_value(ICON_COLUMN, pixbuf)
    end

    def select_icon(file)
      icon_path = lookup_icon_path(file)

      if icon_path
        Gdk::Pixbuf.new(icon_path)
      else
      if Widget.video?(file) or Widget.music?(file)
        self.render_icon_pixbuf(Gtk::Stock::CDROM, :menu)
      else
        self.render_icon_pixbuf(Gtk::Stock::FILE, :menu)
      end
      end
    end

    def lookup_icon_path(file)
      mime_type, uncertain = Gio::ContentType.guess(file)
      content_type = Gio::ContentType.new(mime_type)
      icon = content_type.icon

      icon_theme = Gtk::IconTheme.new
      icon_info = icon_theme.lookup_icon(icon,
                                         16,
                                         Gtk::IconTheme::LookupFlags::GENERIC_FALLBACK)

      if icon_info
        icon_info.filename
      else
        nil
      end
    end
  end
end
