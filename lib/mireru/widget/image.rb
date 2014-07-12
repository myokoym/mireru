require "gtk3"

module Mireru
  module Widget
    class Image < Gtk::Image
      def initialize(file, width, height)
        super()
        pixbuf_animation = Gdk::PixbufAnimation.new(file)
        if pixbuf_animation.static_image?
          pixbuf = pixbuf_animation.static_image
          if pixbuf.width > width || pixbuf.height > height
            pixbuf = Gdk::Pixbuf.new(file, width, height)
          end
          self.pixbuf = pixbuf
        else
          self.pixbuf_animation = pixbuf_animation
        end
      end
    end
  end
end
