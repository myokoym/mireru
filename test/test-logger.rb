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
require "mireru/command/mireru"
require "stringio"

class LoggerTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @logger = Mireru::Logger.new
  end

  def test_info
    s = ""
    io = StringIO.new(s)
    $stdout = io
    message = <<-EOM
#{Mireru::Command::Mireru::USAGE}
  If no argument, then open the current directory.
Keybind:
  n: next
  p: prev
  q: quit
    EOM
    @logger.info(message)
    $stdout = STDOUT
    assert_equal(message, s)
  end

  def test_error
    s = ""
    io = StringIO.new(s)
    $stderr = io
    message = <<-EOM
Warning: valid file not found.
#{Mireru::Command::Mireru::USAGE}
Support file types: png, gif, jpeg(jpg). The others are...yet.
    EOM
    @logger.error(message)
    $stderr = STDERR
    assert_equal(message, s)
  end
end
