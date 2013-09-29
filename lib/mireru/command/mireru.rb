require "gtk3"
require "mireru/logger"
require "mireru/window"
require "mireru/container"
require "mireru/version"

module Mireru
  module Command
    class Mireru
      USAGE = "Usage: mireru [OPTION]... [FILE]..."

      class << self
        def run(*arguments)
          new.run(arguments)
        end
      end

      def initialize
        @logger = ::Mireru::Logger.new
      end

      def run(arguments)
        if /\A(-h|--help)\z/ =~ arguments[0]
          write_help_message
          exit(true)
        elsif /\A(-v|--version)\z/ =~ arguments[0]
          write_version_message
          exit(true)
        end

        font = purge_option(arguments, /\A(-f|--font)\z/, true)

        files = files_from_arguments(arguments)
        file_container = ::Mireru::Container.new(files)

        if file_container.empty?
          write_empty_message
          exit(false)
        end

        window = ::Mireru::Window.new
        window.font = font if font
        window.add_container(file_container)

        Gtk.main
      end

      private
      def files_from_arguments(arguments)
        if arguments.empty?
          files = Dir.glob("*")
        elsif purge_option(arguments, /\A(-R|--recursive|-d|--deep)\z/)
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
        elsif arguments.all? {|v| File.directory?(v) }
          files = []
          arguments.each do |f|
            files << Dir.glob("#{f}/*")
          end
          files.flatten!
        else
          files = arguments
        end
        files
      end

      def purge_option(arguments, regexp, has_value=false)
        index = arguments.find_index {|arg| regexp =~ arg }
        return false unless index
        if has_value
          arguments.delete_at(index) # flag
          arguments.delete_at(index) # value
        else
          arguments.delete_at(index)
        end
      end

      def write_help_message
        message = <<-EOM
#{USAGE}
  If no argument, then search current directory.
Options:
  -R, --recursive
      recursive search as "**/*"
  -f, --font NAME
      set font such as "Monospace 16"
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

  scale:
    +: larger
    -: smaller

  image:
    f: fits window size
    o: original size

  text:
    f: change font (at random)

  video:
    space: play/pause
        EOM
        @logger.info(message)
      end

      def write_version_message
        message = <<-EOM
#{::Mireru::VERSION}
        EOM
        @logger.info(message)
      end

      def write_empty_message
        message = <<-EOM
Warning: file not found.
#{USAGE}
  If no argument, then search current directory.
Options:
  -R, --recursive
      recursive search as "**/*"
  -f, --font NAME
      set font such as "Monospace 16"
        EOM
        @logger.error(message)
      end
    end
  end
end
