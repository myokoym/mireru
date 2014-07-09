require "mireru/widget"

class ThumbnailTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    files = []
    files << File.join(fixtures_dir, "nijip.png")
    @thumbnail = Mireru::Widget::Thumbnail.new(files, 100, 100)
  end

  def test_image_from_file
    widget = @thumbnail.__send__(:image_from_file,
                                 File.join(fixtures_dir, "nijip.png"))
    assert_kind_of(Gtk::Image, widget)
  end

  def test_label_from_fil
    widget = @thumbnail.__send__(:label_from_file, __FILE__)
    assert_kind_of(Gtk::Label, widget)
  end
end
