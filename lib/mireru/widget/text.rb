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

require "gtksourceview3"

module Mireru
  module Widget
    class Text < GtkSource::View
      def initialize(file)
        buffer = buffer_from_file(file)
        super(buffer)
        self.show_line_numbers = true
        lang = GtkSource::LanguageManager.new.get_language("ruby")
        self.buffer.language = lang
        self.buffer.highlight_syntax = true
        self.buffer.highlight_matching_brackets = true
        self.editable = false
        override_font(Pango::FontDescription.new("Monospace"))
      end

      private
      def buffer_from_file(file)
        text = File.open(file).read
        buffer_from_text(text)
      end

      def buffer_from_text(text)
        to = Encoding::UTF_8
        from = guess_encoding(text)
        if to != from
          text.encode!(to,
                       from,
                       {
                         :invalid => :replace,
                         :undef   => :replace,
                       })
        end
        buffer = GtkSource::Buffer.new
        buffer.text = text
        buffer
      end

      def guess_encoding(text)
        return Encoding::UTF_8 if utf8?(text)
        require "nkf"
        NKF.guess(text)
      end

      def utf8?(text)
        text.dup.force_encoding(Encoding::UTF_8).valid_encoding?
      end
    end
  end
end
