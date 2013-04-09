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
      self.signal_connect("destroy") do
        Gtk.main_quit
      end
    end

    def add_container(container)
      @container = container

      @file = @container.shift
      self.add_from_file(@file)

      self.signal_connect("key_press_event") do |w, e|
        case e.keyval
        when Gdk::Keyval::GDK_KEY_n
          @file = @container.shift(@file)
          self.add_from_file(@file)
        when Gdk::Keyval::GDK_KEY_p
          @file = @container.pop(@file)
          self.add_from_file(@file)
        when Gdk::Keyval::GDK_KEY_r
          self.add_from_file(@file)
        when Gdk::Keyval::GDK_KEY_f
          if Mireru::Widget.image?(@file)
            pixbuf = Gdk::Pixbuf.new(@file, *self.size)
            @widget.pixbuf = pixbuf
          end
        when Gdk::Keyval::GDK_KEY_o
          if Mireru::Widget.image?(@file)
            pixbuf = Gdk::Pixbuf.new(@file)
            @widget.pixbuf = pixbuf
          end
        when Gdk::Keyval::GDK_KEY_h
          @scroll.hadjustment.value -= 17
        when Gdk::Keyval::GDK_KEY_j
          @scroll.vadjustment.value += 17
        when Gdk::Keyval::GDK_KEY_k
          @scroll.vadjustment.value -= 17
        when Gdk::Keyval::GDK_KEY_l
          @scroll.hadjustment.value += 17
        when Gdk::Keyval::GDK_KEY_q
          Gtk.main_quit
        end
      end
    end

    def add_from_file(file)
      @scroll.each {|child| @scroll.remove(child) }
      @widget = Mireru::Widget.create(file, *self.size)
      if @widget.is_a?(Gtk::Scrollable)
        @scroll.add(@widget)
      else
        @scroll.add_with_viewport(@widget)
      end
      @scroll.hadjustment.lower
      @scroll.vadjustment.lower
      self.title = File.basename(file)
      self.show_all
    end
  end
end
