require "mireru/window"

class WindowTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @window = Mireru::Window.new([])
  end

  class AddFromFileTest
    def test_scrollable
      file = __FILE__
      mock(Mireru::Widget).new(file, *@window.size) do
        Gtk::TextView.new
      end
      mock(@window).show_all
      @window.add_from_file(file)
      assert_equal(Gtk::ScrolledWindow, @window.child.class)
      assert_equal(Gtk::TextView, @window.child.child.class)
    end

    def test_no_scrollable
      file = File.join(fixtures_dir, "nijip.png")
      mock(Mireru::Widget).new(file, *@window.size) do
        Gtk::Image.new
      end
      mock(@window).show_all
      @window.add_from_file(file)
      assert_equal(Gtk::ScrolledWindow, @window.child.class)
      assert_equal(Gtk::Viewport, @window.child.child.class)
      assert_equal(Gtk::Image, @window.child.child.child.class)
    end

    def test_enumable
      file = [__FILE__]
      @window.add_from_file(file)
      assert_equal(Mireru::Widget::Thumbnail, @window.child.child.class)
    end
  end
end
