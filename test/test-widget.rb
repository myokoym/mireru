require "mireru/widget"

class WidgetTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_image?
    assert_nil(Mireru::Widget.image?(__FILE__))
    assert_not_nil(Mireru::Widget.image?("test/fixtures/nijip.png"))
    assert_not_nil(Mireru::Widget.image?("hoge.PNG"))
    assert_not_nil(Mireru::Widget.image?("hoge.jpg"))
    assert_not_nil(Mireru::Widget.image?("hoge.jpeg"))
    assert_not_nil(Mireru::Widget.image?("hoge.gif"))
  end
end
