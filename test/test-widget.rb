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

require "mireru/widget"

class WidgetTest < Test::Unit::TestCase
  include MireruTestUtils

  class ImageTest < self
    def test_not_image
      assert_nil(Mireru::Widget.image?(__FILE__))
    end

    def test_png
      assert_not_nil(Mireru::Widget.image?("test/fixtures/nijip.png"))
    end

    def test_uppercase
      assert_not_nil(Mireru::Widget.image?("hoge.PNG"))
    end

    def test_jpg
      assert_not_nil(Mireru::Widget.image?("hoge.jpg"))
    end

    def test_jpeg
      assert_not_nil(Mireru::Widget.image?("hoge.jpeg"))
    end

    def test_gif
      assert_not_nil(Mireru::Widget.image?("hoge.gif"))
    end
  end
end
