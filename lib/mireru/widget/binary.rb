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
require "stringio"
require "hexdump"

module Mireru
  module Widget
    class Binary < Gtk::TextView
      def initialize(file)
        text = hexdump(file).string
        buffer = Gtk::TextBuffer.new
        buffer.text = text
        super(buffer)
        editable = false
        override_font(Pango::FontDescription.new("Monospace"))
      end

      private
      def hexdump(file)
        io = StringIO.new
        bytes = File.open(file, "rb").read(20 * 1024)
        Hexdump.dump(bytes, :output => io)
        io
      end
    end
  end
end
