require "mireru/command/mireru"
require "stringio"

module ValidTests
  def test_no_argument
    s = ""
    io = StringIO.new(s)
    $stdout = io
    valid = @mireru.__send__(:valid?, [])
    $stdout = STDOUT
    assert_false(valid)
    assert_equal(<<-EOT, s)
Error: no argument.
#{Mireru::Command::Mireru::USAGE}
    EOT
  end

  def test_missing_file
    s = ""
    io = StringIO.new(s)
    $stdout = io
    valid = @mireru.__send__(:valid?, ["hoge"])
    $stdout = STDOUT
    assert_false(valid)
    assert_equal(<<-EOT, s)
Error: missing file.
#{Mireru::Command::Mireru::USAGE}
    EOT
  end

  def test_not_support_file_type
    s = ""
    io = StringIO.new(s)
    $stdout = io
    valid = @mireru.__send__(:valid?, [__FILE__])
    $stdout = STDOUT
    assert_false(valid)
    assert_equal(<<-EOT, s)
Error: this file type is not support as yet.
#{Mireru::Command::Mireru::USAGE}
    EOT
  end
end

class TestMireru < Test::Unit::TestCase
  def setup
    @mireru = Mireru::Command::Mireru.new
  end

  include ValidTests
end
