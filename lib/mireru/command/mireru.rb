require 'gtk3'

module Mireru
  module Command
    class Mireru
      USAGE = "Usage: mireru <file path>"

      class << self
        def run(*arguments)
          new.run(arguments)
        end
      end

      def initialize
      end

      def run(arguments)
        file = arguments[0]

        unless file
          puts("Error: no argument.")
          puts(USAGE)
          exit(false)
        end

        unless File.file?(file)
          puts("Error: missing file.")
          puts(USAGE)
          exit(false)
        end

        unless /\.(png|jpe?g|gif)$/i =~ file
          puts("Error: this file type is not support as yet.")
          puts(USAGE)
          exit(false)
        end

        image = Gtk::Image.new(file)
        
        window = Gtk::Window.new

        window.signal_connect("destroy") do
          Gtk.main_quit
        end

        window.border_width = 10
        window.add(image)
        window.show_all
        
        Gtk.main
      end
    end
  end
end
