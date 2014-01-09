module Mireru
  module Widget
    class Image
      class << self
        def create(file, width, height)
          image = Gtk::Image.new
          pixbuf = Gdk::Pixbuf.new(file)
          if pixbuf.width > width || pixbuf.height > height
            pixbuf = Gdk::Pixbuf.new(file, width, height)
          end
          image.pixbuf = pixbuf
          widget = image
        end
      end
    end
  end
end
