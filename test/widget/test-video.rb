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

require "mireru/widget/video"
require "clutter-gtk"

class VideoTest < Test::Unit::TestCase
  include MireruTestUtils
  include ClutterTestUtils

  def test_new
    omit_if_clutter_color_hash_expect_arguments

    filename = "XXX.ogm"
    widget = Mireru::Widget::Video.new(filename)
    assert_not_nil(widget)
    assert_kind_of(ClutterGtk::Embed, widget)
    widget.destroy
  end
end
