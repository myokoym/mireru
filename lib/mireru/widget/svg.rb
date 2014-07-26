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
require "rsvg2"

module Mireru
  module Widget
    class SVG < Gtk::DrawingArea
      def initialize(file)
        super()
        handle = RSVG::Handle.new_from_file(file)
        width, height = handle.dimensions.to_a

        signal_connect("draw") do |widget, event|
          context = widget.window.create_cairo_context
          window_width = widget.allocated_width
          window_height = widget.allocated_height
          width_scale = window_width.to_f / width
          height_scale = window_height.to_f / height
          scale = [width_scale, height_scale].min
          begin
            context.scale(scale, scale)
          rescue => e
            $stderr.puts("#{e.class}: #{e.message}")
            $stderr.puts(e.backtrace)
          end
          context.render_rsvg_handle(handle)
          true
        end
      end
    end
  end
end
