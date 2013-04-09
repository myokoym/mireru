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
        elsif /\A(-d|--deep)\z/ =~ arguments[0]
          arguments.shift
          if arguments.empty?
            files = Dir.glob("**/*")
          else
            files = []
            arguments.each do |f|
              if File.directory?(f)
                files << Dir.glob("#{f}/**/*")
              else
                files << f
              end
            end
            files.flatten!
          end
          file_container = ::Mireru::Container.new(files)
        else
          files = arguments
          file_container = ::Mireru::Container.new(files)
        end

        if file_container.empty?
          write_empty_message
          exit(false)
        end

        window = ::Mireru::Window.new
        window.add_container(file_container)

        Gtk.main
      end

      private
      def write_help_message
        message = <<-EOM
#{USAGE}
  If no argument, then search current directory.
Options:
  -d, --deep: deep search
Keybind:
  n: next
  p: prev
  r: reload
  e: expand path
  q: quit

  scroll:
    h: left
    j: down
    k: up
    l: right

  image:
    f: fits window size
    o: original size
        EOM
        @logger.info(message)
      end

      def write_empty_message
        message = <<-EOM
Warning: file not found.
#{USAGE}
  If no argument, then search current directory.
        EOM
        @logger.error(message)
      end
    end
  end
end
