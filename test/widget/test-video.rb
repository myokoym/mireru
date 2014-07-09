require "mireru/widget/video"
require "clutter-gtk"

class VideoTest < Test::Unit::TestCase
  include MireruTestUtils
  include ClutterTestUtils

  def test_create
    omit_if_clutter_color_hash_expect_arguments

    filename = "XXX.ogm"
    widget = Mireru::Widget::Video.create(filename)
    assert_not_nil(widget)
    assert_kind_of(ClutterGtk::Embed, widget)
    widget.destroy
  end
end
