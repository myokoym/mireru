require 'gtk3'

module Misere
  module Command
    class Misere

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
          puts("Usage: misere <file path>")
          exit(false)
        end

        unless File.file?(file)
          puts("Error: missing file.")
          puts("Usage: misere <file path>")
          exit(false)
        end

        unless /\.(png|jpe?g|gif)$/i =~ file
          puts("Error: this file type is not support as yet.")
          puts("Usage: misere <file path>")
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
