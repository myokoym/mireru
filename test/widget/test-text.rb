# -*- coding: utf-8 -*-
require "mireru/widget/text"

class TextTest < Test::Unit::TestCase
  def test_buffer_from_file_of_text
    widget = Mireru::Widget::Text.__send__(:buffer_from_file, __FILE__)
    assert_equal(GtkSource::Buffer, widget.class)
  end

  def test_buffer_from_text_of_utf8
    widget = Mireru::Widget::Text.__send__(:buffer_from_text, "御庭番")
    assert_equal(GtkSource::Buffer, widget.class)
  end

  def test_buffer_from_text_of_sjis
    widget = Mireru::Widget::Text.__send__(:buffer_from_text, "御庭番".encode("SJIS"))
    assert_equal(GtkSource::Buffer, widget.class)
  end
end
