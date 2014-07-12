require "gtk3"
require "rsvg2"

module Mireru
  module Widget
    class SVG < Gtk::DrawingArea
      def initialize(file)
        super()
        handle = RSVG::Handle.new_from_file(file)
        width, height = handle.dimensions.to_a

        signal_connect("draw") do |widget, event|
          context = widget.window.create_cairo_context
          window_width = widget.allocated_width
          window_height = widget.allocated_height
          width_scale = window_width.to_f / width
          height_scale = window_height.to_f / height
          scale = [width_scale, height_scale].min
          begin
            context.scale(scale, scale)
          rescue => e
            $stderr.puts("#{e.class}: #{e.message}")
            $stderr.puts(e.backtrace)
          end
          context.render_rsvg_handle(handle)
          true
        end
      end
    end
  end
end
