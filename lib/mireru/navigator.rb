require "gtk3"
require "pathname"

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
      column.title = File.dirname(base_dir)
      tree_view.append_column(column)

      renderer = Gtk::CellRendererPixbuf.new
      renderer.set_fixed_size(*Gtk::IconSize.lookup(:menu))
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

    def load_files(model, base_dir)
      icon_width, icon_height = Gtk::IconSize.lookup(:menu)
      dir_icon = self.render_icon_pixbuf(Gtk::Stock::DIRECTORY, :menu)
      file_icon = self.render_icon_pixbuf(Gtk::Stock::FILE, :menu)

      base_iter = model.append(parent)
      base_iter.set_value(PATH_COLUMN, base_dir)
      base_iter.set_value(FILENAME_COLUMN, File.basename(base_dir))
      base_iter.set_value(ICON_COLUMN, dir_icon)

      parents = {}
      parents[base_dir] = base_iter

      target_files(base_dir).each do |file|
        parent_iter = parents[File.dirname(file)] || parent_iter
        iter = model.append(parent_iter)
        iter.set_value(PATH_COLUMN, file)
        iter.set_value(FILENAME_COLUMN, File.basename(file))
        if File.directory?(file)
          parents[file] = iter
          iter.set_value(ICON_COLUMN, dir_icon)
        else
          iter.set_value(ICON_COLUMN, file_icon)
          # TODO: too slow...
          #begin
          #  pixbuf = Gdk::Pixbuf.new(file, icon_width, icon_height)
          #rescue Gdk::PixbufError
          #  pixbuf = file_icon
          #end
          #iter.set_value(ICON_COLUMN, pixbuf)
        end
      end
    end

    def target_files(base_dir)
      return @target_files if @target_files
      @target_files = []
      @files.each do |file|
        search_target_pathes(file, base_dir).each do |file|
          @target_files << file
        end
      end
      @target_files.sort!
      @target_files.uniq!
      @target_files
    end

    def search_target_pathes(target_file, base_dir)
      target_pathes = []
      parent_directories(target_file, base_dir).each do |parent|
        target_pathes << parent
      end
      target_pathes << File.expand_path(target_file)
      target_pathes
    end

    def parent_directories(path, base_dir)
      directories = []
      pathname = Pathname.new(path).expand_path
      loop do
        break if pathname.root?
        break if pathname.parent.to_s == base_dir
        parent = pathname.parent
        directories << parent.to_s
        pathname = parent
      end
      directories.sort!
      directories
    end
  end
end
