# Copyright (C) 2013-2014 Masafumi Yokoyama <myokoym@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

require "optparse"
require "mireru/logger"
require "mireru/window"
require "mireru/version"

module Mireru
  class Command
    USAGE = "Usage: mireru [OPTION]... [FILE_OR_DIRECTORY]..."

    class << self
      def run(*arguments)
        new.run(arguments)
      end
    end

    def initialize
      @logger = Logger.new
    end

    def run(arguments)
      options = parse_options(arguments)

      files = files_from_arguments(arguments)

      window = Window.new(files, options)

      window.run
    end

    private
    def parse_options(arguments)
      options = {}

      parser = OptionParser.new
      parser.on("-h", "--help",
                "Show help message") do
        write_help_message
        exit(true)
      end
      parser.on("-v", "--version",
                "Show version number") do
        write_version_message
        exit(true)
      end
      parser.on("-f", "--font=NAME",
                "Set a font such as \"Monospace 16\"") do |name|
        options[:font] = name
      end
      parser.on("--regexp=PATTERN",
                "Select file name by regular expression pattern") do |pattern|
        options[:regexp] = pattern
      end
      parser.parse!(arguments)

      options
    end

    def files_from_arguments(arguments)
      if arguments.empty?
        files = [Dir.pwd]
      else
        files = arguments
      end
      files
    end

    def write_help_message
      message = <<-EOM
#{USAGE}
  If no argument, then open the current directory.

Options:
  -h, --help
      show this help message

  -f, --font NAME
      set a font such as "Monospace 16"

Key bindings:
  n: next
  p: prev
  e: expand/collapse
  r: reload
  q: quit

  E: extract text using ChupaText

  Control key mask:
    Ctrl+n: 10 tiles next
    Ctrl+p: 10 tiles prev
    Ctrl+e: expand all / collapse even if cursor on file
    Ctrl+h: move position of partition to left
    Ctrl+l: move position of partition to right
    Ctrl+Enter: run selected file (only supports Windows and OS X)

  scroll:
    h: left
    j: down
    k: up
    l: right

    H: 100 times left
    J: 100 times down
    K: 100 times up
    L: 100 times right

    G: down to bottom

  scale:
    +: larger
    -: smaller

  image:
    f: fit window size
    o: scale to the original size

  text:
    f: change font (at random)

  video:
    space: play/pause

  PDF:
    j: next page
    k: prev page
      EOM
      @logger.info(message)
    end

    def write_version_message
      message = <<-EOM
#{VERSION}
      EOM
      @logger.info(message)
    end
  end
end
