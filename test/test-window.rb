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

require "mireru/window"

class WindowTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @window = Mireru::Window.new([])
  end

  class AddFromFileTest
    def test_scrollable
      file = __FILE__
      mock(Mireru::Widget).new(file, *@window.size) do
        Gtk::TextView.new
      end
      mock(@window).show_all
      @window.add_from_file(file)
      assert_equal(Gtk::ScrolledWindow, @window.child.class)
      assert_equal(Gtk::TextView, @window.child.child.class)
    end

    def test_no_scrollable
      file = File.join(fixtures_dir, "nijip.png")
      mock(Mireru::Widget).new(file, *@window.size) do
        Gtk::Image.new
      end
      mock(@window).show_all
      @window.add_from_file(file)
      assert_equal(Gtk::ScrolledWindow, @window.child.class)
      assert_equal(Gtk::Viewport, @window.child.child.class)
      assert_equal(Gtk::Image, @window.child.child.child.class)
    end
  end
end
