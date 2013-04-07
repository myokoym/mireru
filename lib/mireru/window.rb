require 'gtk3'
require "mireru/widget"

module Mireru
  class Window < Gtk::Window
    def add_from_file(file)
      self.remove(@widget) if @widget
      @widget = Mireru::Widget.create(file)
      self.add(@widget)
      self.show_all
      self.title = File.basename(file)
      self.resize(1, 1)
    end
  end
end
