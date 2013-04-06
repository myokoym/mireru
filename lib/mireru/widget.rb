require 'gtk3'

module Mireru
  class Widget
    def self.create(file)
      case File.extname(file)
      when /\A\.(png|jpe?g|gif)\z/i
        image = Gtk::Image.new
        image.file = file
        widget = image
      when /\A\.(txt|rb)\z/i
        buffer = Gtk::TextBuffer.new
        buffer.text = File.open(file).read
        text = Gtk::TextView.new(buffer)
        text.editable = false
        widget = text
      else
        raise "coding error: uncheck file type."
      end
      widget
    end
  end
end
