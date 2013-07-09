require "mireru/command/mireru"
require "mireru/container"

class MireruTest < Test::Unit::TestCase
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

  def test_run_empty
    arguments = %w(hoge)
    stub(@mireru).files_from_arguments { arguments }
    mock.instance_of(Mireru::Container).empty? { true }
    mock(@mireru).write_empty_message
    assert_raise SystemExit do
      @mireru.run(arguments)
    end
  end

  def test_files_from_arguments_no_argument
    arguments = %w()
    expected = %w(dir1 file1 dir2)
    mock(Dir).glob("*") { expected }
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments_deep_option_only
    arguments = %w(-R)
    expected = %w(dir1 file1 dir2 dir1/file1 dir1/file2 dir2/file1)
    mock(Dir).glob("**/*") { expected }
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments_deep_option_and_dir
    arguments = %w(-R dir1 file1 dir2)
    expected_dir1 = %w(dir1/file1 dir1/file2)
    expected_dir2 = %w(dir2/file1)
    expected = [expected_dir1, "file1", expected_dir2].flatten
    mock(File).directory?("dir1") { true }
    mock(File).directory?("file1") { false }
    mock(File).directory?("dir2") { true }
    mock(Dir).glob("dir1/**/*") { expected_dir1 }
    mock(Dir).glob("dir2/**/*") { expected_dir2 }
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments_all_dir
    arguments = %w(dir1 dir2)
    expected_dir1 = %w(dir1/file1 dir1/file2)
    expected_dir2 = %w(dir2/file1)
    expected = [expected_dir1, expected_dir2].flatten
    mock(File).directory?("dir1") { true }
    mock(File).directory?("dir2") { true }
    mock(Dir).glob("dir1/*") { expected_dir1 }
    mock(Dir).glob("dir2/*") { expected_dir2 }
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, expected)
  end

  def test_files_from_arguments_else
    arguments = %w(dir1 file1 dir2)
    files = @mireru.__send__(:files_from_arguments, arguments)
    assert_equal(files, arguments)
  end

  def test_purge_option
    arguments = %w(-R -f ubuntu dir1 file1 dir2)
    flag = @mireru.__send__(:purge_option, arguments, /\A(-R|--recursive)\z/)
    assert_not_nil(flag)
    assert_equal(%w(-f ubuntu dir1 file1 dir2), arguments)
    value = @mireru.__send__(:purge_option, arguments, /\A-f\z/, true)
    assert_equal("ubuntu", value)
    assert_equal(%w(dir1 file1 dir2), arguments)
  end
end
