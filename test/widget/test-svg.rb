require "mireru/widget/svg"

class SVGTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_create
    file = File.join(File.dirname(__FILE__), "..", "fixtures", "sample.svg")
    widget = Mireru::Widget::SVG.create(file)
    assert_not_nil(widget)
    assert_equal(Gtk::DrawingArea, widget.class)
    widget.destroy
  end
end
