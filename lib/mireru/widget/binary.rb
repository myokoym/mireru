require "gtk3"
require "stringio"
require "hexdump"

module Mireru
  module Widget
    class Binary < Gtk::TextView
      def initialize(file)
        text = hexdump(file).string
        buffer = Gtk::TextBuffer.new
        buffer.text = text
        super(buffer)
        editable = false
        override_font(Pango::FontDescription.new("Monospace"))
      end

      private
      def hexdump(file)
        io = StringIO.new
        bytes = File.open(file, "rb").read(20 * 1024)
        Hexdump.dump(bytes, :output => io)
        io
      end
    end
  end
end
