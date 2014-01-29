require "mireru/widget/pdf"

class PDFTest < Test::Unit::TestCase
  def test_create
    file = File.join(File.dirname(__FILE__), "..", "fixtures", "sample.pdf")
    widget = Mireru::Widget::PDF.create(file)
    assert_not_nil(widget)
    assert_equal(Gtk::DrawingArea, widget.class)
    widget.destroy
  end
end
