require 'gtk3'

module Mireru
  module Command
    class Mireru
      USAGE = "Usage: mireru [FILE...]"

      class << self
        def run(*arguments)
          new.run(arguments)
        end
      end

      def initialize
      end

      def run(arguments)
        if arguments.empty?
          file_container = Dir.glob("*")
        else
          file_container = arguments
        end

        file_container.select! {|f| support_file?(f) }

        if file_container.empty?
          puts("Error: no argument.")
          puts(USAGE)
          exit(false)
        end

        image = Gtk::Image.new
        image.file = file_container.shift

        window = Gtk::Window.new

        window.signal_connect("key_press_event") do |w, e|
          case e.keyval
          when Gdk::Keyval::GDK_KEY_n
            file_container.push(image.file)
            image.file = file_container.shift
          when Gdk::Keyval::GDK_KEY_p
            file_container.unshift(image.file)
            image.file = file_container.pop
          when Gdk::Keyval::GDK_KEY_q
            Gtk.main_quit
          end
        end

        window.signal_connect("destroy") do
          Gtk.main_quit
        end

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

      def support_file?(file)
        unless file
          return false
        end

        unless File.file?(file)
          return false
        end

        unless /\.(png|jpe?g|gif)$/i =~ file
          return false
        end

        true
      end
    end
  end
end
