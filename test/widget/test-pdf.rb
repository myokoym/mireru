require "mireru/widget/pdf"

class PDFTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_new
    file = File.join(fixtures_dir, "sample.pdf")
    widget = Mireru::Widget::PDF.new(file)
    assert_not_nil(widget)
    assert_kind_of(Gtk::DrawingArea, widget)
    widget.destroy
  end
end
