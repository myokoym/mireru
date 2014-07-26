require "gtk3"
require "chupa-text"
gem "chupa-text-decomposer-pdf"
gem "chupa-text-decomposer-libreoffice"

ChupaText::Decomposers.load

# TODO: workaround for a multibyte filename.
module URI
  class Generic
    alias :path_raw :path
    def path
      URI.decode_www_form_component(path_raw, Encoding.find("locale"))
    end
  end

  def self.parse(uri)
    uri = URI.encode_www_form_component(uri)
    DEFAULT_PARSER.parse(uri)
  end
end

module Mireru
  module Widget
    class ExtractedText < Gtk::TextView
      def initialize(file)
        buffer = buffer_from_file(file)
        super(buffer)
        self.editable = false
      end

      private
      def buffer_from_file(file)
        extractor = ChupaText::Extractor.new
        extractor.apply_configuration(ChupaText::Configuration.default)

        text = ""
        extractor.extract(file) do |extracted_data|
          text << extracted_data.body
        end

        buffer_from_text(text)
      end

      def buffer_from_text(text)
        text.encode!("utf-8") unless text.encoding == "utf-8"
        buffer = Gtk::TextBuffer.new
        buffer.text = text
        buffer
      end
    end
  end
end
