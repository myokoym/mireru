require "mireru/widget/svg"

class SVGTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_new
    file = File.join(File.dirname(__FILE__), "..", "fixtures", "sample.svg")
    widget = Mireru::Widget::SVG.new(file)
    assert_not_nil(widget)
    assert_kind_of(Gtk::DrawingArea, widget)
    widget.destroy
  end
end
