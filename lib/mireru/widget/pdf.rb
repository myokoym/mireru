require "gtk3"
require "poppler"

module Mireru
  module Widget
    class PDF < Gtk::DrawingArea
      def initialize(file)
        super()
        document = Poppler::Document.new(file)
        @page_index = 0
        @page_max = document.size - 1
        width, height = document.first.size
        set_size_request(width, height)

        signal_connect("draw") do |widget, event|
          context = widget.window.create_cairo_context
          context.render_poppler_page(document[@page_index])
          context.show_page
          true
        end
      end

      def next
        @page_index += 1
        @page_index = @page_max if @page_index > @page_max
        hide
        show
      end

      def prev
        @page_index -= 1
        @page_index = 0 if @page_index < 0
        hide
        show
      end
    end
  end
end
