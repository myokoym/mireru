require 'gtk3'

module Mireru
  class Widget
    def self.create(file)
      case File.extname(file)
      when /\A\.(png|jpe?g|gif)\z/i
        image = Gtk::Image.new
        image.file = file
        widget = image
      else
        require 'gtksourceview3'
        text = File.open(file).read
        return sorry unless text.valid_encoding?
        buffer = GtkSource::Buffer.new
        buffer.text = text
        view = GtkSource::View.new(buffer)
        view.show_line_numbers = true
        lang = GtkSource::LanguageManager.new.get_language('ruby')
        view.buffer.language = lang
        view.buffer.highlight_syntax = true
        view.buffer.highlight_matching_brackets = true
        view.editable = false
        widget = view
      end
      widget
    end

    private
    def self.sorry
      image = Gtk::Image.new
      image.file = "images/sorry.png"
      image
    end
  end
end
