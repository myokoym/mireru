require "gtk3"
require "gtksourceview3"
require "mireru/widget/image"
require "mireru/widget/video"
require "mireru/widget/binary"

module Mireru
  class Widget
    class << self
      def create(file, width=10000, height=10000)
        if image?(file)
          widget = Mireru::Image.create(file)
        elsif video?(file)
          widget = Mireru::Video.create(file)
        elsif text?(file)
          widget = Mireru::Text.create(file)
        else
          widget = Mireru::Binary.create(file)
        end
        widget
      end

      def image?(file)
        /\.(png|jpe?g|gif|ico|ani|bmp|pnm|ras|tga|tiff|xbm|xpm)\z/i =~ file
      end

      def video?(file)
        /\.(ogm|mp4|flv|mpe?g2?|ts|mov|avi|divx|mkv|wmv|asf|wmx)\z/i =~ file
      end

      def text?(file)
        File.read(file).valid_encoding?
      end
    end
  end
end
