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

require "mireru/widget/image"
require "mireru/widget/text"
require "mireru/widget/binary"

module Mireru
  module Widget
    module_function
    def create(file, width, height, chupa=false, binary=false)
      if chupa
        check do
          require "mireru/widget/extracted_text"
          return Widget::ExtractedText.new(file)
        end
      end
      if binary
        return Widget::Binary.new(file)
      end

      if image?(file)
        return Widget::Image.new(file, width, height)
      end

      if video?(file) or music?(file)
        check do
          require "mireru/widget/video"
          return Widget::Video.new(file)
        end
      end

      if pdf?(file)
        check do
          require "mireru/widget/pdf"
          return Widget::PDF.new(file)
        end
      end

      if svg?(file)
        check do
          require "mireru/widget/svg"
          return Widget::SVG.new(file)
        end
      end

      if text?(file)
        return Widget::Text.new(file)
      end

      return Widget::Binary.new(file)
    end

    # TODO: improve
    def check
      begin
        yield
      rescue LoadError
        $stderr.puts("Warning: #{$!.message}")
      end
    end

    def image?(file)
      /\.(png|jpe?g|gif|ico|ani|bmp|pnm|ras|tga|tiff|xbm|xpm)\z/i =~ file
    end

    def music?(file)
      /\.(og[ag]|wav|acc|mp3|m4a|wma|flac|tta|aiff|ape|tak)\z/i =~ file
    end

    def video?(file)
      /\.(ogm|mp4|m4v|flv|mpe?g2?|ts|mov|avi|divx|mkv|wmv|asf|wmx)\z/i =~ file
    end

    def pdf?(file)
      /\.pdf\z/i =~ file
    end

    def svg?(file)
      /\.svg\z/i =~ file
    end

    def document?(file)
      /\.(odt|ods|odp|doc|xls|ppt|docx|xlsx|pptx)\z/i =~ file
    end

    def text?(file)
      return false if binary?(file)
      true
    end

    def binary?(file)
      if /\.(la|lo|o|so|a|dll|exe|msi|tar|gz|zip|7z|lzh|rar|iso)\z/i =~ file
        true
      else
        bytes = File.read(file, 512)
        return false if bytes.nil?
        return false if utf16?(bytes)
        bytes.count("\x00-\x07\x0b\x0e-\x1a\x1c-\x1f") > (bytes.size / 10)
      end
    end

    def utf16?(bytes)
      # TODO: simplify
      (bytes.start_with?("\xff\xfe".force_encoding("ASCII-8BIT")) or
         bytes.start_with?("\xfe\xff".force_encoding("ASCII-8BIT"))) and
        bytes.count("\x01-\x07\x0b\x0e-\x1a\x1c-\x1f") < (bytes.size / 20)
    end
  end
end
