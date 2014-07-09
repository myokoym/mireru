require "mireru/widget/svg"

class SVGTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_create
    file = File.join(File.dirname(__FILE__), "..", "fixtures", "sample.svg")
    widget = Mireru::Widget::SVG.create(file)
    assert_not_nil(widget)
    assert_kind_of(Gtk::DrawingArea, widget)
    widget.destroy
  end
end
