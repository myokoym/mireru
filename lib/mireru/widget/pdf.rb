# TODO: workaround for Ruby/Poppler 2.1.0 or earlier.
module Kernel
  alias :__require__ :require
  def require(feature)
    return if feature == "gtk2"
    __require__(feature)
  end
end
require "poppler"

module Mireru
  module Widget
    class PDF
      class << self
        def create(file)
          drawing_area = Gtk::DrawingArea.new

          document = Poppler::Document.new(file)
          width, height = document.first.size
          drawing_area.set_size_request(width, height * document.size)

          drawing_area.signal_connect("draw") do |widget, event|
            context = widget.window.create_cairo_context
            document.each_with_index do |page, i|
              context.save do
                context.translate(0, height * i)
                context.render_poppler_page(document[i])
              end
            end
            context.show_page
            true
          end

          drawing_area
        end
      end
    end
  end
end
