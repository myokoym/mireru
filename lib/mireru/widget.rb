require "mireru/widget/image"
require "mireru/widget/video"
require "mireru/widget/pdf"
require "mireru/widget/svg"
require "mireru/widget/text"
require "mireru/widget/binary"
require "mireru/widget/thumbnail"

module Mireru
  module Widget
    module_function
    def create(file, width=10000, height=10000)
      if file.is_a?(Enumerable)
        widget = Mireru::Widget::Thumbnail.new(file, width, height)
      elsif image?(file)
        widget = Mireru::Widget::Image.new(file, width, height)
      elsif video?(file) or music?(file)
        widget = Mireru::Widget::Video.new(file)
      elsif pdf?(file)
        widget = Mireru::Widget::PDF.new(file)
      elsif svg?(file)
        widget = Mireru::Widget::SVG.new(file)
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
      /\.(ogm|mp4|flv|mpe?g2?|ts|mov|avi|divx|mkv|wmv|asf|wmx)\z/i =~ file
    end

    def pdf?(file)
      /\.pdf\z/i =~ file
    end

    def svg?(file)
      /\.svg\z/i =~ file
    end

    def text?(file)
      File.read(file).valid_encoding?
    end
  end
end
