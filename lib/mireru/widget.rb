require 'gtk3'

module Mireru
  class Widget
    def self.create(file)
      case File.extname(file)
      when /\A\.(png|jpe?g|gif)\z/i
        image = Gtk::Image.new
        image.file = file
        widget = image
      when /\A\.(txt)\z/i
        buffer = Gtk::TextBuffer.new
        buffer.text = File.open(file).read
        text = Gtk::TextView.new(buffer)
        text.editable = false
        widget = text
      when /\A\.(rb)\z/i
        require 'gtksourceview3'
        buffer = Gtk::SourceBuffer.new
        buffer.text = File.open(file).read
        view = Gtk::SourceView.new(buffer)
        view.show_line_numbers = true
        lang = Gtk::SourceLanguageManager.new.get_language('ruby')
        view.buffer.language = lang
        view.buffer.highlight_syntax = true
        view.buffer.highlight_matching_brackets = true
        view.editable = false
        widget = view
      else
        raise "coding error: uncheck file type."
      end
      widget
    end
  end
end
