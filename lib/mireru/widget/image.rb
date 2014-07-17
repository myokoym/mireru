require "gtk3"

module Mireru
  module Widget
    class Image < Gtk::Image
      def initialize(file, width, height)
        super()
        pixbuf_animation = Gdk::PixbufAnimation.new(file)
        if pixbuf_animation.static_image?
          self.pixbuf = pixbuf_animation.static_image
          if pixbuf.width > width || pixbuf.height > height
            scale_preserving_aspect_ratio(width, height)
          end
        else
          self.pixbuf_animation = pixbuf_animation
        end
      end

      def scale_preserving_aspect_ratio(width, height)
        x_ratio = width.to_f / pixbuf.width
        y_ratio = height.to_f / pixbuf.height
        ratio = [x_ratio, y_ratio].min
        self.pixbuf = pixbuf.scale(pixbuf.width * ratio,
                                   pixbuf.height * ratio)
      end
    end
  end
end
