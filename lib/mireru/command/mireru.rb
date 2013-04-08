require 'gtk3'
require "mireru/logger"
require "mireru/window"
require "mireru/container"

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
        @logger = ::Mireru::Logger.new
      end

      def run(arguments)
        if arguments.empty?
          files = Dir.glob("*")
          file_container = ::Mireru::Container.new(files)
        elsif /\A(-h|--help)\z/ =~ arguments[0]
          write_help_message
          exit(true)
        else
          files = arguments
          file_container = ::Mireru::Container.new(files)
        end

        if file_container.empty?
          write_empty_message
          exit(false)
        end

        file = file_container.shift

        window = ::Mireru::Window.new
        window.add_from_file(file)

        window.signal_connect("key_press_event") do |w, e|
          case e.keyval
          when Gdk::Keyval::GDK_KEY_n
            file = file_container.shift(file)
            window.add_from_file(file)
          when Gdk::Keyval::GDK_KEY_p
            file = file_container.pop(file)
            window.add_from_file(file)
          when Gdk::Keyval::GDK_KEY_r
            window.add_from_file(file)
          when Gdk::Keyval::GDK_KEY_q
            Gtk.main_quit
          end
        end

        window.signal_connect("destroy") do
          Gtk.main_quit
        end

        Gtk.main
      end

      private
      def write_help_message
        message = <<-EOM
#{USAGE}
  If no argument, then search current directory.
Keybind:
  n: next
  p: prev
  r: reload
  q: quit
        EOM
        @logger.info(message)
      end

      def write_empty_message
        message = <<-EOM
Warning: valid file not found.
#{USAGE}
Support file types: png, gif, jpeg(jpg). The others are...yet.
        EOM
        @logger.error(message)
      end
    end
  end
end
