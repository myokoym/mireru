require "gtksourceview3"

module Mireru
  module Widget
    class Text < GtkSource::View
      class << self
        def create(file)
          new(file)
        end
      end

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
        text.encode!("utf-8") unless text.encoding == "utf-8"
        buffer = GtkSource::Buffer.new
        buffer.text = text
        buffer
      end
    end
  end
end
