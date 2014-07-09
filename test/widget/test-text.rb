# -*- coding: utf-8 -*-
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
