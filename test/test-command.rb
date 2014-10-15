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

require "mireru/command"

class CommandTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @command = Mireru::Command.new
  end

  def test_run_help_option
    arguments = %w(--help)
    mock(@command).write_help_message
    assert_raise SystemExit do
      @command.run(arguments)
    end
  end

  def test_run_help_option_sugar
    arguments = %w(-h)
    mock(@command).write_help_message
    assert_raise SystemExit do
      @command.run(arguments)
    end
  end

  def test_run_version_option
    arguments = %w(--version)
    mock(@command).write_version_message
    assert_raise SystemExit do
      @command.run(arguments)
    end
  end

  def test_files_from_arguments_no_argument
    arguments = %w()
    expected = [Dir.pwd]
    files = @command.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments
    arguments = %w(dir1 dir2)
    expected = %w(dir1 dir2)
    files = @command.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_purge_option
    arguments = %w(-f ubuntu dir1 file1 dir2)
    value = @command.__send__(:purge_option, arguments, /\A-f\z/, true)
    assert_equal("ubuntu", value)
    assert_equal(%w(dir1 file1 dir2), arguments)
  end
end
