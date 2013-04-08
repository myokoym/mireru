require "mireru/window"

class TestWindow < Test::Unit::TestCase
  def setup
    @window = Mireru::Window.new
  end

  def test_add_container
    container = %w(a, b, c)
    mock(container).shift { "a" }
    mock(@window).add_from_file("a")
    @window.add_container(container)
  end

  def test_add_from_file_of_scrollable
    file = __FILE__
    mock(Mireru::Widget).create(file, *@window.size) do
      Gtk::TextView.new
    end
    mock(@window).show_all
    @window.add_from_file(file)
    assert_equal(Gtk::ScrolledWindow, @window.child.class)
    assert_equal(Gtk::TextView, @window.child.child.class)
  end

  def test_add_from_file_of_no_scrollable
    file = "fixtures/nijip.png"
    mock(Mireru::Widget).create(file, *@window.size) do
      Gtk::Image.new
    end
    mock(@window).show_all
    @window.add_from_file(file)
    assert_equal(Gtk::ScrolledWindow, @window.child.class)
    assert_equal(Gtk::Viewport, @window.child.child.class)
    assert_equal(Gtk::Image, @window.child.child.child.class)
  end
end
