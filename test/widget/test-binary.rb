require "mireru/widget/binary"

class BinaryTest < Test::Unit::TestCase
  include MireruTestUtils

  def test_create
    file = File.join(fixtures_dir, "Gemfile.gz")
    widget = Mireru::Widget::Binary.create(file)
    assert_not_nil(widget)
    assert_kind_of(Gtk::TextView, widget)
    widget.destroy
  end
end
