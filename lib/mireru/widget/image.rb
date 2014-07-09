require "gtk3"

module Mireru
  module Widget
    class Image < Gtk::Image
      def initialize(file, width, height)
        super
        pixbuf = Gdk::Pixbuf.new(file)
        if pixbuf.width > width || pixbuf.height > height
          pixbuf = Gdk::Pixbuf.new(file, width, height)
        end
        self.pixbuf = pixbuf
      end
    end
  end
end
