require 'gtk3'

module Mireru
  module Command
    class Mireru
      USAGE = "Usage: mireru FILE"

      class << self
        def run(*arguments)
          new.run(arguments)
        end
      end

      def initialize
      end

      def run(arguments)
        exit(false) unless valid?(arguments)

        file = arguments[0]

        image = Gtk::Image.new
        image.file = file

        window = Gtk::Window.new

        window.signal_connect("destroy") do
          Gtk.main_quit
        end

        window.border_width = 10
        window.add(image)
        window.show_all

        Gtk.main
      end

      private
      def valid?(arguments)
        file = arguments[0]

        unless file
          puts("Error: no argument.")
          puts(USAGE)
          return false
        end

        unless File.file?(file)
          puts("Error: missing file.")
          puts(USAGE)
          return false
        end

        unless /\.(png|jpe?g|gif)$/i =~ file
          puts("Error: this file type is not support as yet.")
          puts(USAGE)
          return false
        end

        true
      end
    end
  end
end
