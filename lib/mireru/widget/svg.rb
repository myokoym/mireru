require "rsvg2"

module Mireru
  module Widget
    class SVG < Gtk::DrawingArea
      class << self
        def create(file)
          new(file)
        end
      end

      def initialize(file)
        super()
          handle = RSVG::Handle.new_from_file(file)
          width, height = handle.dimensions.to_a
          set_size_request(width, height)

          signal_connect("draw") do |widget, event|
            context = widget.window.create_cairo_context
            context.save do
              context.render_rsvg_handle(handle)
            end
            true
          end
      end
    end
  end
end
