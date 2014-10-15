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
      if /\A(-h|--help)\z/ =~ arguments[0]
        write_help_message
        exit(true)
      elsif /\A(-v|--version)\z/ =~ arguments[0]
        write_version_message
        exit(true)
      end

      font = purge_option(arguments, /\A(-f|--font)\z/, true)

      files = files_from_arguments(arguments)

      window = Window.new(files)
      window.font = font if font

      window.run
    end

    private
    def files_from_arguments(arguments)
      if arguments.empty?
        files = [Dir.pwd]
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
