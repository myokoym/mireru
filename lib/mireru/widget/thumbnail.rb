require "gtk3"
require "mireru/widget"

module Mireru
  module Widget
    class Thumbnail < Gtk::Box
      def initialize(files, width, height)
        super(:vertical)
        nums_in_a_row = Math.sqrt(files.size)
        files.each_slice(nums_in_a_row) do |a_row_files|
          row = Gtk::Box.new(:horizontal)
          a_row_files.each do |file|
            cell_width  = width  / nums_in_a_row
            cell_height = height / nums_in_a_row
            if Widget.image?(file)
              image = image_from_file(file, cell_width, cell_height)
              add(image)
            else
              label = label_from_file(file, cell_width, cell_height)
              add(label)
            end
          end
          add(row)
        end
      end

      private
      def image_from_file(file, width=100, height=100)
        image = Gtk::Image.new
        pixbuf = Gdk::Pixbuf.new(file, width, height)
        image.pixbuf = pixbuf
        image
      end

      def label_from_file(file, width=100, height=100)
        label = Gtk::Label.new(File.basename(file))
        label.set_size_request(width, height)
        label.wrap = true
        label
      end
    end
  end
end
