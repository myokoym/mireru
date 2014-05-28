require "rsvg2"

module Mireru
  module Widget
    class SVG
      class << self
        def create(file)
          drawing_area = Gtk::DrawingArea.new

          handle = RSVG::Handle.new_from_file(file)
          width, height = handle.dimensions.to_a
          drawing_area.set_size_request(width, height)

          drawing_area.signal_connect("draw") do |widget, event|
            context = widget.window.create_cairo_context
            context.save do
              context.render_rsvg_handle(handle)
            end
            true
          end

          drawing_area
        end
      end
    end
  end
end
