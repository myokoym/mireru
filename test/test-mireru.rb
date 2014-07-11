require "mireru/command/mireru"

class MireruTest < Test::Unit::TestCase
  include MireruTestUtils

  def setup
    @mireru = Mireru::Command::Mireru.new
  end

  def test_run_help_option
    arguments = %w(--help)
    mock(@mireru).write_help_message
    assert_raise SystemExit do
      @mireru.run(arguments)
    end
  end

  def test_run_help_option_sugar
    arguments = %w(-h)
    mock(@mireru).write_help_message
    assert_raise SystemExit do
      @mireru.run(arguments)
    end
  end

  def test_run_version_option
    arguments = %w(--version)
    mock(@mireru).write_version_message
    assert_raise SystemExit do
      @mireru.run(arguments)
    end
  end

  def test_files_from_arguments_no_argument
    arguments = %w()
    expected = [Dir.pwd]
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments
    arguments = %w(dir1 dir2)
    expected = %w(dir1 dir2)
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_purge_option
    arguments = %w(-f ubuntu dir1 file1 dir2)
    value = @mireru.__send__(:purge_option, arguments, /\A-f\z/, true)
    assert_equal("ubuntu", value)
    assert_equal(%w(dir1 file1 dir2), arguments)
  end
end
