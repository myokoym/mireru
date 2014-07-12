require "gtk3"
require "poppler"

module Mireru
  module Widget
    class PDF < Gtk::DrawingArea
      def initialize(file)
        super()
        document = Poppler::Document.new(file)
        width, height = document.first.size
        set_size_request(width, height * document.size)

        signal_connect("draw") do |widget, event|
          context = widget.window.create_cairo_context
          context.render_poppler_page(document[0])
          context.show_page
          true
        end
      end
    end
  end
end
