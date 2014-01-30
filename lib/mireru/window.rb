require "gtk3"
require "mireru/widget"
require "mireru/widget/thumbnail"

module Mireru
  class Window < Gtk::Window
    attr_accessor :font
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
        when Gdk::Keyval::GDK_KEY_e
          self.title = File.expand_path(@file)
        when Gdk::Keyval::GDK_KEY_f
          if Mireru::Widget.image?(@file)
            pixbuf = Gdk::Pixbuf.new(@file, *self.size)
            @widget.pixbuf = pixbuf
          elsif @widget.is_a?(Gtk::TextView)
            font = @widget.pango_context.families.sample.name
            @widget.override_font(Pango::FontDescription.new(font))
            self.title = "#{File.basename(@file)} (#{font})"
          end
        when Gdk::Keyval::GDK_KEY_o
          if Mireru::Widget.image?(@file)
            pixbuf = Gdk::Pixbuf.new(@file)
            @widget.pixbuf = pixbuf
          end
        when Gdk::Keyval::GDK_KEY_T
          files = @container.instance_variable_get(:@files)
          self.add_from_file(files)
        when Gdk::Keyval::GDK_KEY_plus
          if Mireru::Widget.image?(@file)
            width  = @widget.pixbuf.width
            height = @widget.pixbuf.height
            scale = 1.1
            pixbuf = Gdk::Pixbuf.new(@file,
                                     width * scale,
                                     height * scale)
            @widget.pixbuf = pixbuf
          elsif @widget.is_a?(Gtk::TextView)
            font = @widget.pango_context.font_description.to_s
            font_size = font.scan(/\d+\z/).first.to_i
            font = font.sub(/\d+\z/, (font_size + 1).to_s)
            @widget.override_font(Pango::FontDescription.new(font))
          end
        when Gdk::Keyval::GDK_KEY_minus
          if Mireru::Widget.image?(@file)
            width  = @widget.pixbuf.width
            height = @widget.pixbuf.height
            scale = 0.9
            pixbuf = Gdk::Pixbuf.new(@file,
                                     width * scale,
                                     height * scale)
            @widget.pixbuf = pixbuf
          elsif @widget.is_a?(Gtk::TextView)
            font = @widget.pango_context.font_description.to_s
            font_size = font.scan(/\d+\z/).first.to_i
            font = font.sub(/\d+\z/, (font_size - 1).to_s)
            @widget.override_font(Pango::FontDescription.new(font))
          end
        when Gdk::Keyval::GDK_KEY_h
          @scroll.hadjustment.value -= 17
        when Gdk::Keyval::GDK_KEY_j
          @scroll.vadjustment.value += 17
        when Gdk::Keyval::GDK_KEY_k
          @scroll.vadjustment.value -= 17
        when Gdk::Keyval::GDK_KEY_l
          @scroll.hadjustment.value += 17
        when Gdk::Keyval::GDK_KEY_H
          @scroll.hadjustment.value -= 1000000
        when Gdk::Keyval::GDK_KEY_J, Gdk::Keyval::GDK_KEY_G
          @scroll.vadjustment.value += 1000000
        when Gdk::Keyval::GDK_KEY_K
          @scroll.vadjustment.value -= 1000000
        when Gdk::Keyval::GDK_KEY_L
          @scroll.hadjustment.value += 1000000
        when Gdk::Keyval::GDK_KEY_q
          Gtk.main_quit
        end
      end
    end

    def add_from_file(file)
      @scroll.hadjustment.value = 0
      @scroll.vadjustment.value = 0
      @scroll.each {|child| child.destroy }
      if file.is_a?(Enumerable)
        @widget = Mireru::Widget::Thumbnail.create(file, *self.size)
        self.title = "Thumbnails: #{file.size} / #{file.size}"
      else
        @widget = Mireru::Widget.create(file, *self.size)
        self.title = File.basename(file)
      end
      @widget.override_font(Pango::FontDescription.new(@font)) if @font
      if @widget.is_a?(Gtk::Scrollable)
        @scroll.add(@widget)
      else
        @scroll.add_with_viewport(@widget)
      end
      self.show_all
    end
  end
end
