require "mireru/binary"

class BinaryTest < Test::Unit::TestCase
  def test_create
    file = File.join(File.dirname(__FILE__), "fixtures", "Gemfile.gz")
    widget = Mireru::Binary.create(file)
    assert_not_nil(widget)
    assert_equal(Gtk::TextView, widget.class)
    widget.destroy
  end
end
