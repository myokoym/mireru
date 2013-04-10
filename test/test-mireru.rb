require "mireru/command/mireru"

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
end
