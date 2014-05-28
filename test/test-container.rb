require "mireru/container"

class ContainerTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @container = Mireru::Container.new
  end

  def test_size
    assert_equal(0, @container.size)
    files = @container.instance_variable_get(:@files)
    files << __FILE__
    assert_equal(1, @container.size)
    files << __FILE__
    assert_equal(2, @container.size)
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
    file = File.join(fixtures_dir, "no-extention")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_png_file
    file = File.join(fixtures_dir, "nijip.png")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_txt_file
    file = File.join(fixtures_dir, "LICENSE.txt")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end

  def test_rb_file
    file = File.join(fixtures_dir, "nijip.rb")
    valid = @container.__send__(:file?, file)
    assert_true(valid)
  end
end
