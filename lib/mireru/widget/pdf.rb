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
            document.each_with_index do |page, i|
              context.save do
                context.translate(0, height * i)
                context.render_poppler_page(document[i])
              end
            end
            context.show_page
            true
          end
      end

      class << self
        def create(file)
          new(file)
        end
      end
    end
  end
end
