module Mireru
  module Widget
  class Text
    class << self
      def create(file)
        buffer = buffer_from_file(file)
        view = GtkSource::View.new(buffer)
        view.show_line_numbers = true
        lang = GtkSource::LanguageManager.new.get_language("ruby")
        view.buffer.language = lang
        view.buffer.highlight_syntax = true
        view.buffer.highlight_matching_brackets = true
        view.editable = false
        view.override_font(Pango::FontDescription.new("Monospace"))
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
end
