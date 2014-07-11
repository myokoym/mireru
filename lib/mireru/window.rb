require "gtk3"
require "mireru/widget"
require "mireru/navigator"

module Mireru
  class Window < Gtk::Window
    attr_accessor :font
    attr_accessor :file
    def initialize(files)
      super()
      @files = files

      @paned = Gtk::Paned.new(:horizontal)
      add(@paned)

      @navigator = Navigator.new(self, files)
      @paned.add(@navigator)

      @scroll = Gtk::ScrolledWindow.new
      @scroll.set_policy(:automatic, :automatic)
      @paned.add(@scroll)

      set_default_size(800, 600)
      signal_connect("destroy") do
        Gtk.main_quit
      end

      define_keybind
    end

    def define_keybind
      signal_connect("key-press-event") do |widget, event|
        if event.state.control_mask?
          action_from_keyval_with_control_mask(event.keyval)
        else
          action_from_keyval(event.keyval)
        end
      end
    end

    def action_from_keyval(keyval)
      case keyval
      when Gdk::Keyval::GDK_KEY_n
        @navigator.next
      when Gdk::Keyval::GDK_KEY_p
        @navigator.prev
      when Gdk::Keyval::GDK_KEY_r
        # TODO: reload
      when Gdk::Keyval::GDK_KEY_e
        @navigator.expand_toggle
      when Gdk::Keyval::GDK_KEY_f
        if Mireru::Widget.image?(@file)
          allocation = @scroll.allocation
          pixbuf = Gdk::Pixbuf.new(@file,
                                   allocation.width,
                                   allocation.height)
          @widget.pixbuf = pixbuf
        elsif @widget.is_a?(Gtk::TextView)
          font = @widget.pango_context.families.sample.name
          @widget.override_font(Pango::FontDescription.new(font))
        end
      when Gdk::Keyval::GDK_KEY_o
        if Mireru::Widget.image?(@file)
          pixbuf = Gdk::Pixbuf.new(@file)
          @widget.pixbuf = pixbuf
        end
      when Gdk::Keyval::GDK_KEY_T
        # TODO: thumbnail
      when Gdk::Keyval::GDK_KEY_plus
        if Mireru::Widget.image?(@file)
          pixbuf = @widget.pixbuf
          scale = 1.1
          @widget.pixbuf = pixbuf.scale(pixbuf.width  * scale,
                                        pixbuf.height * scale)
        elsif @widget.is_a?(Gtk::TextView)
          font = @widget.pango_context.font_description.to_s
          font_size = font.scan(/\d+\z/).first.to_i
          font = font.sub(/\d+\z/, (font_size + 1).to_s)
          @widget.override_font(Pango::FontDescription.new(font))
        end
      when Gdk::Keyval::GDK_KEY_minus
        if Mireru::Widget.image?(@file)
          pixbuf = @widget.pixbuf
          scale = 0.9
          @widget.pixbuf = pixbuf.scale(pixbuf.width  * scale,
                                        pixbuf.height * scale)
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
        destroy
      end
    end

    def action_from_keyval_with_control_mask(keyval)
      case keyval
      when Gdk::Keyval::GDK_KEY_n
        10.times { @navigator.next }
      when Gdk::Keyval::GDK_KEY_p
        10.times { @navigator.prev }
      when Gdk::Keyval::GDK_KEY_e
        @navigator.expand_toggle(true)
      when Gdk::Keyval::GDK_KEY_h
        @paned.position -= 2
      when Gdk::Keyval::GDK_KEY_l
        @paned.position += 2
      end
    end

    def add_from_file(file)
      @scroll.hadjustment.value = 0
      @scroll.vadjustment.value = 0
      @scroll.each do |child|
        @scroll.remove(child)
        child.destroy
      end
      @widget = Mireru::Widget.create(file, *self.size)
      @widget.override_font(Pango::FontDescription.new(@font)) if @font
      if @widget.is_a?(Gtk::Scrollable)
        @scroll.add(@widget)
      else
        @scroll.add_with_viewport(@widget)
      end
      show_all
    end
  end
end
