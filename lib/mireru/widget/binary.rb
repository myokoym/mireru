require "stringio"
require "hexdump"

module Mireru
  module Widget
  class Binary
    class << self
      def create(file)
        dump = hexdump(file).string
        create_text_view(dump)
      end

      private
      def hexdump(file)
        io = StringIO.new
        bytes = File.open(file, "rb").read(20 * 1024)
        Hexdump.dump(bytes, :output => io)
        io
      end

      def create_text_view(text)
        buffer = Gtk::TextBuffer.new
        buffer.text = text
        view = Gtk::TextView.new(buffer)
        view.editable = false
        view.override_font(Pango::FontDescription.new("Monospace"))
        view
      end
    end
  end
  end
end
