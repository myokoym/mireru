require "mireru/widget/image"
require "mireru/widget/video"
require "mireru/widget/pdf"
require "mireru/widget/svg"
require "mireru/widget/document"
require "mireru/widget/text"
require "mireru/widget/binary"

module Mireru
  module Widget
    module_function
    def create(file, width, height)
      if image?(file)
        widget = Mireru::Widget::Image.new(file, width, height)
      elsif video?(file) or music?(file)
        widget = Mireru::Widget::Video.new(file)
      elsif pdf?(file)
        widget = Mireru::Widget::PDF.new(file)
      elsif svg?(file)
        widget = Mireru::Widget::SVG.new(file)
      elsif document?(file)
        widget = Mireru::Widget::Document.new(file)
      elsif text?(file)
        widget = Mireru::Widget::Text.new(file)
      else
        widget = Mireru::Widget::Binary.new(file)
      end
      widget
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
