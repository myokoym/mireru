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

module Mireru
  module Widget
    class Image < Gtk::Image
      def initialize(file, width, height)
        super()
        @pixbuf = Gdk::PixbufAnimation.new(file)
        if @pixbuf.static_image?
          @pixbuf = @pixbuf.static_image
          if @pixbuf.width > width || @pixbuf.height > height
            scale_preserving_aspect_ratio(width, height)
          end
          self.pixbuf = @pixbuf
        else
          self.pixbuf_animation = @pixbuf
        end
      end

      def scale_preserving_aspect_ratio(width, height)
        if @pixbuf.is_a?(Gdk::PixbufAnimation)
          @pixbuf = @pixbuf.static_image
        end
        x_ratio = width.to_f / @pixbuf.width
        y_ratio = height.to_f / @pixbuf.height
        ratio = [x_ratio, y_ratio].min
        self.pixbuf = @pixbuf.scale(@pixbuf.width * ratio,
                                    @pixbuf.height * ratio)
      end
    end
  end
end
