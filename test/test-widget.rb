require "mireru/widget"

class TestWidget < Test::Unit::TestCase
  def test_buffer_from_file_of_text
    widget = Mireru::Widget.__send__(:buffer_from_file, __FILE__)
    assert_equal(GtkSource::Buffer, widget.class)
  end

  def test_buffer_from_file_of_binary
    assert_raise Mireru::Error do
      Mireru::Widget.__send__(:buffer_from_file, "test/fixtures/nijip.png")
    end
  end

  def test_buffer_from_text_of_utf8
    widget = Mireru::Widget.__send__(:buffer_from_text, "御庭番")
    assert_equal(GtkSource::Buffer, widget.class)
  end

  def test_buffer_from_text_of_sjis
    widget = Mireru::Widget.__send__(:buffer_from_text, "御庭番".encode("SJIS"))
    assert_equal(GtkSource::Buffer, widget.class)
  end
end
