require 'gtk3'
require "mireru/logger"
require "mireru/window"

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
          file_container = Dir.glob("*")
        elsif /\A(-h|--help)\z/ =~ arguments[0]
          message = <<-EOM
#{USAGE}
  If no argument, then search current directory.
Keybind:
  n: next
  p: prev
  q: quit
          EOM
          @logger.info(message)
          exit(true)
        else
          file_container = arguments
        end

        file_container.select! {|f| support_file?(f) }

        if file_container.empty?
          message = <<-EOM
Warning: valid file not found.
#{USAGE}
Support file types: png, gif, jpeg(jpg). The others are...yet.
          EOM
          @logger.error(message)
          exit(false)
        end

        file = file_container.shift

        window = ::Mireru::Window.new
        window.add_from_file(file)

        window.signal_connect("key_press_event") do |w, e|
          case e.keyval
          when Gdk::Keyval::GDK_KEY_n
            file_container.push(file)
            file = file_container.shift
            window.add_from_file(file)
          when Gdk::Keyval::GDK_KEY_p
            file_container.unshift(file)
            file = file_container.pop
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
      def support_file?(file)
        unless file
          return false
        end

        unless File.file?(file)
          return false
        end

        unless /\.(png|jpe?g|gif|txt|rb)$/i =~ file
          return false
        end

        true
      end
    end
  end
end
