require "mireru/command/mireru"

module ValidTests
  def test_no_argument
    valid = @mireru.__send__(:support_file?, nil)
    assert_false(valid)
  end

  def test_missing_file
    valid = @mireru.__send__(:support_file?, "hoge")
    assert_false(valid)
  end

  def test_not_support_file_type
    file = File.join(File.dirname(__FILE__), "fixtures", "no-extention")
    valid = @mireru.__send__(:support_file?, file)
    assert_false(valid)
  end

  def test_png_file
    file = File.join(File.dirname(__FILE__), "fixtures", "nijip.png")
    valid = @mireru.__send__(:support_file?, file)
    assert_true(valid)
  end

  def test_txt_file
    file = File.join(File.dirname(__FILE__), "fixtures", "LICENSE.txt")
    valid = @mireru.__send__(:support_file?, file)
    assert_true(valid)
  end

  def test_rb_file
    file = File.join(File.dirname(__FILE__), "fixtures", "nijip.rb")
    valid = @mireru.__send__(:support_file?, file)
    assert_true(valid)
  end
end

class TestMireru < Test::Unit::TestCase
  def setup
    @mireru = Mireru::Command::Mireru.new
  end

  include ValidTests
end
