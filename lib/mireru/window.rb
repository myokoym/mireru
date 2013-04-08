require 'gtk3'
require "mireru/widget"

module Mireru
  class Window < Gtk::Window
    def initialize
      super
      @scroll = Gtk::ScrolledWindow.new
      @scroll.set_policy(:automatic, :automatic)
      self.add(@scroll)
      self.set_default_size(640, 640)
    end

    def add_from_file(file)
      @scroll.each {|child| @scroll.remove(child) }
      @widget = Mireru::Widget.create(file)
      if @widget.is_a?(Gtk::Scrollable)
        @scroll.add(@widget)
      else
        @scroll.add_with_viewport(@widget)
      end
      self.title = File.basename(file)
      self.show_all
    end
  end
end
