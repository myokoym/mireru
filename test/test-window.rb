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

  class AddFromFileTest < self
    def test_textview
      file = __FILE__
      stub(Mireru::Widget).create do
        Gtk::TextView.new
      end
      stub(@window).show_all
      @window.add_from_file(file)
      pane = @window.child
      scrolled_window = pane.child2
      widget = scrolled_window.child
      assert_kind_of(Gtk::TextView, widget)
    end

    def test_viewport
      file = File.join(fixtures_dir, "nijip.png")
      stub(Mireru::Widget).create do
        Gtk::Image.new
      end
      stub(@window).show_all
      @window.add_from_file(file)
      pane = @window.child
      scrolled_window = pane.child2
      view_port = scrolled_window.child
      assert_kind_of(Gtk::Viewport, view_port)
      widget = view_port.child
      assert_kind_of(Gtk::Image, widget)
    end
  end
end
