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
        widget = Mireru::Widget::Thumbnail.create(file, width, height)
      elsif image?(file)
        widget = Mireru::Widget::Image.create(file, width, height)
      elsif video?(file)
        widget = Mireru::Widget::Video.create(file)
      elsif pdf?(file)
        widget = Mireru::Widget::PDF.create(file)
      elsif svg?(file)
        widget = Mireru::Widget::SVG.create(file)
      elsif text?(file)
        widget = Mireru::Widget::Text.create(file)
      else
        widget = Mireru::Widget::Binary.create(file)
      end
      widget
    end

    def image?(file)
      /\.(png|jpe?g|gif|ico|ani|bmp|pnm|ras|tga|tiff|xbm|xpm)\z/i =~ file
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
