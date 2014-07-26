# -*- coding: utf-8 -*-
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

require "mireru/widget/text"

class TextTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @view = Mireru::Widget::Text.new(__FILE__)
  end

  def test_buffer_from_file_of_text
    buffer = @view.__send__(:buffer_from_file, __FILE__)
    assert_kind_of(GtkSource::Buffer, buffer)
  end

  def test_buffer_from_text_of_utf8
    buffer = @view.__send__(:buffer_from_text, "御庭番")
    assert_kind_of(GtkSource::Buffer, buffer)
  end

  def test_buffer_from_text_of_sjis
    buffer = @view.__send__(:buffer_from_text, "御庭番".encode("SJIS"))
    assert_kind_of(GtkSource::Buffer, buffer)
  end
end
