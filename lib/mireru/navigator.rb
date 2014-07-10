require "gtk3"

module Mireru
  class Navigator < Gtk::ScrolledWindow
    PATH_COLUMN, FILENAME_COLUMN, ICON_COLUMN = 0, 1, 2

    def initialize(window, files)
      if Dir.glob(files).empty?
        raise ArgumentError, "\"#{files}\" is not found."
      end

      super()
      @window = window
      @files = files
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
      if @tree_view.row_expanded?(path)
        @tree_view.collapse_row(path)
      else
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

      if @files.all? {|file| File.expand_path(file).include?(Dir.pwd) }
        base_dir = Dir.pwd
      elsif @files.all? {|file| File.expand_path(file).include?(File.expand_path("~")) }
        base_dir = File.expand_path("~")
      else
        base_dir = File.expand_path("/")
      end
      load_files(model, base_dir)

      column = Gtk::TreeViewColumn.new
      column.title = base_dir
      tree_view.append_column(column)

      renderer = Gtk::CellRendererPixbuf.new
      renderer.width = 0
      column.pack_start(renderer, :expand => false)
      column.add_attribute(renderer, :pixbuf, ICON_COLUMN)

      renderer = Gtk::CellRendererText.new
      column.pack_start(renderer, :expand => false)
      column.add_attribute(renderer, :text, FILENAME_COLUMN)

      selection.signal_connect("changed") do |selection|
        iter = selection.selected
        next unless iter
        path = iter.get_value(PATH_COLUMN)
        next unless File.file?(path)
        @window.title = path
        @window.file = path
        begin
          @window.add_from_file(path)
        rescue
          stock = Gtk::Stock::MISSING_IMAGE
          size = :dialog
          pixbuf = Gtk::Image.new.render_icon_pixbuf(stock, size)
        end
      end

      tree_view.expand_all
      tree_view
    end

    def load_files(model, dir=nil, parent=nil)
      if @files.all? {|file| File.directory?(file) }
        @files.each do |dir|
          load_files(model, dir, parent)
        end
        return
      elsif dir.nil?
        dir = Dir.pwd
      end

      icon_width, icon_height = Gtk::IconSize.lookup(:menu)
      dir_icon = self.render_icon_pixbuf(Gtk::Stock::DIRECTORY, :menu)
      file_icon = self.render_icon_pixbuf(Gtk::Stock::FILE, :menu)

      return unless include_target_file?(dir)
      parent_iter = model.append(parent)
      parent_iter.set_value(PATH_COLUMN, dir)
      parent_iter.set_value(FILENAME_COLUMN, File.basename(dir))
      parent_iter.set_value(ICON_COLUMN, dir_icon)

      Dir.glob("#{dir}/*").each do |path|
        if File.directory?(path)
          load_files(model, path, parent_iter)
        elsif include_target_file?(path)
          iter = model.append(parent_iter)
          iter.set_value(PATH_COLUMN, path)
          iter.set_value(FILENAME_COLUMN, File.basename(path))
          begin
            pixbuf = Gdk::Pixbuf.new(path, icon_width, icon_height)
          rescue Gdk::PixbufError
            pixbuf = file_icon
          end
          iter.set_value(ICON_COLUMN, pixbuf)
        end
      end
    end

    def include_target_file?(path)
      @files.each do |file|
        return true if File.expand_path(file).include?(path)
      end
      false
    end
  end
end
