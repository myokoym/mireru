require "mireru/container"

class TestContainer< Test::Unit::TestCase
  def setup
    @container = Mireru::Container.new
  end

  def test_no_argument
    valid = @container.__send__(:file?, nil)
    assert_false(valid)
  end

  def test_missing_file
    valid = @container.__send__(:file?, "hoge")
    assert_false(valid)
  end

  def test_no_extention_file_type
    file = File.join(File.dirname(__FILE__), "fixtures", "no-extention")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_png_file
    file = File.join(File.dirname(__FILE__), "fixtures", "nijip.png")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_txt_file
    file = File.join(File.dirname(__FILE__), "fixtures", "LICENSE.txt")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_rb_file
    file = File.join(File.dirname(__FILE__), "fixtures", "nijip.rb")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end
end
