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
require "poppler"

module Mireru
  module Widget
    class PDF < Gtk::DrawingArea
      def initialize(file)
        super()
        document = Poppler::Document.new(file)
        @page_index = 0
        @page_max = document.size - 1
        width, height = document.first.size
        set_size_request(width, height)

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
          context.render_poppler_page(document[@page_index])
          context.show_page
          true
        end
      end

      def next
        @page_index += 1
        @page_index = @page_max if @page_index > @page_max
        hide
        show
      end

      def prev
        @page_index -= 1
        @page_index = 0 if @page_index < 0
        hide
        show
      end
    end
  end
end
