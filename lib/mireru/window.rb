# Copyright (C) 2013-2014 Masafumi Yokoyama <myokoym@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

require "gtk3"
require "mireru/widget"
require "mireru/navigator"
require "mireru/status_bar"

module Mireru
  class Window < Gtk::Window
    attr_accessor :file
    def initialize(files, options={})
      super()
      @files = files
      @font = options[:font]

      @paned = Gtk::Paned.new(:horizontal)
      add(@paned)

      @navigator = Navigator.new(self, files, options)
      @paned.add(@navigator)

      @main_vbox = Gtk::Box.new(:vertical)
      @paned.add(@main_vbox)

      @scroll = Gtk::ScrolledWindow.new
      @scroll.set_policy(:automatic, :automatic)
      @main_vbox.pack_start(@scroll, :expand  => true,
                                     :fill    => true,
                                     :padding => 0)

      @status_bar = StatusBar.new
      @main_vbox.pack_end(@status_bar, :expand  => false,
                                       :fill    => false,
                                       :padding => 0)

      @default_width = options[:width] || 800
      @default_height = options[:height] || 600
      set_default_size(@default_width, @default_height)
      signal_connect("destroy") do
        Gtk.main_quit
      end

      define_keybind
    end

    def add_from_file(file, chupa=false)
      @scroll.hadjustment.value = 0
      @scroll.vadjustment.value = 0
      @scroll.each do |child|
        @scroll.remove(child)
        child.destroy
      end
      width = @scroll.allocated_width - 10
      height = @scroll.allocated_height - 10
      @widget = Mireru::Widget.create(file, width, height, chupa)
      @widget.override_font(Pango::FontDescription.new(@font)) if @font
      if @widget.is_a?(Gtk::Scrollable)
        @scroll.add(@widget)
      else
        @scroll.add_with_viewport(@widget)
      end
      @status_bar.set_file(file)
      show_all
    end

    def run
      show_all
      Gtk.main
    end

    private
    def define_keybind
      signal_connect("key-press-event") do |widget, event|
        handled = false

        if event.state.control_mask?
          handled = action_from_keyval_with_control_mask(event.keyval)
        else
          handled = action_from_keyval(event.keyval)
        end

        handled
      end
    end

    def action_from_keyval(keyval)
      case keyval
      when Gdk::Keyval::KEY_n
        @navigator.next
      when Gdk::Keyval::KEY_p
        @navigator.prev
      when Gdk::Keyval::KEY_r
        add_from_file(@file)  # reload
      when Gdk::Keyval::KEY_e
        @navigator.expand_toggle
      when Gdk::Keyval::KEY_Return
        @navigator.expand_toggle
      when Gdk::Keyval::KEY_space
        if @widget.is_a?(Widget::Video)
          @widget.pause_or_play
        end
      when Gdk::Keyval::KEY_f
        if Mireru::Widget.image?(@file)
          width = @scroll.allocated_width - 10
          height = @scroll.allocated_height - 10
          @widget.scale_preserving_aspect_ratio(width, height)
        elsif @widget.is_a?(Gtk::TextView)
          font = @widget.pango_context.families.sample.name
          @widget.override_font(Pango::FontDescription.new(font))
        end
      when Gdk::Keyval::KEY_o
        if Mireru::Widget.image?(@file)
          pixbuf = Gdk::Pixbuf.new(@file)
          @widget.pixbuf = pixbuf
        end
      when Gdk::Keyval::KEY_plus
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
      when Gdk::Keyval::KEY_minus
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
      when Gdk::Keyval::KEY_E
        add_from_file(@file, true)
      when Gdk::Keyval::KEY_h
        @scroll.hadjustment.value -= 17
      when Gdk::Keyval::KEY_j
        if @widget.is_a?(Widget::PDF)
          @widget.next
        else
        @scroll.vadjustment.value += 17
        end
      when Gdk::Keyval::KEY_k
        if @widget.is_a?(Widget::PDF)
          @widget.prev
        else
        @scroll.vadjustment.value -= 17
        end
      when Gdk::Keyval::KEY_l
        @scroll.hadjustment.value += 17
      when Gdk::Keyval::KEY_H
        @scroll.hadjustment.value -= 17 * 100
      when Gdk::Keyval::KEY_J
        @scroll.vadjustment.value += 17 * 100
      when Gdk::Keyval::KEY_G
        @scroll.vadjustment.value = @scroll.vadjustment.upper
      when Gdk::Keyval::KEY_K
        @scroll.vadjustment.value -= 17 * 100
      when Gdk::Keyval::KEY_L
        @scroll.hadjustment.value += 17 * 100
      when Gdk::Keyval::KEY_q
        destroy
      else
        return false
      end
      true
    end

    def action_from_keyval_with_control_mask(keyval)
      case keyval
      when Gdk::Keyval::KEY_n
        10.times { @navigator.next }
      when Gdk::Keyval::KEY_p
        10.times { @navigator.prev }
      when Gdk::Keyval::KEY_e
        @navigator.expand_toggle(true)
      when Gdk::Keyval::KEY_h
        @paned.position -= 2
      when Gdk::Keyval::KEY_l
        @paned.position += 2
      when Gdk::Keyval::KEY_Return
        execute_selected_file
      else
        return false
      end
      true
    end

    def execute_selected_file
      command = nil

      case RUBY_PLATFORM
      when /mswin|mingw|bccwin/
        command = "start"
      when /darwin/
        command = "open"
      else
        $stderr.puts(<<-END_OF_MESSAGE)
Ctrl+Enter is not supported in this platform (#{RUBY_PLATFORM}).
Only supports Windows (use `start` command) and OS X (use `open` command).
        END_OF_MESSAGE
        return
      end

      spawn(command, @file.encode("locale"))
    end
  end
end
