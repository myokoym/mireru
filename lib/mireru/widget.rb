require "gtk3"
require "gtksourceview3"
require "mireru/widget/image"
require "mireru/widget/video"
require "mireru/widget/binary"

module Mireru
  class Error < StandardError
  end

  class Widget
    class << self
      def create(file, width=10000, height=10000)
        if image?(file)
          widget = Mireru::Image.create(file)
        elsif video?(file)
          widget = Mireru::Video.create(file)
        else
          begin
            buffer = buffer_from_file(file)
          rescue Mireru::Error
            return Mireru::Binary.create(file)
          end
          view = GtkSource::View.new(buffer)
          view.show_line_numbers = true
          lang = GtkSource::LanguageManager.new.get_language("ruby")
          view.buffer.language = lang
          view.buffer.highlight_syntax = true
          view.buffer.highlight_matching_brackets = true
          view.editable = false
          view.override_font(Pango::FontDescription.new("Monospace"))
          widget = view
        end
        widget
      end

      def image?(file)
        /\.(png|jpe?g|gif|ico|ani|bmp|pnm|ras|tga|tiff|xbm|xpm)\z/i =~ file
      end

      def video?(file)
        /\.(ogm|mp4|flv|mpe?g2?|ts|mov|avi|divx|mkv|wmv|asf|wmx)\z/i =~ file
      end

      private
      def buffer_from_file(file)
        text = File.open(file).read
        buffer_from_text(text)
      end

      def buffer_from_text(text)
        # TODO: at times the error don't occurred by tar file
        raise Mireru::Error unless text.valid_encoding?
        text.encode!("utf-8") unless text.encoding == "utf-8"
        buffer = GtkSource::Buffer.new
        buffer.text = text
        buffer
      end
    end
  end
end
