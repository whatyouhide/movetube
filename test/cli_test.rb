require_relative 'test_helper'

class CLITest < MiniTest::Unit::TestCase
  def setup
    @cli = Movetube::CLI
  end

  def test_responds_to_the_run_method
    assert_respond_to @cli, :run
  end

  def test_help_works
    out, err = capture_subprocess_io do
      success = system 'bin/movetube --help'
      assert success, 'the bin/movetube command failed'
    end

    assert_match /NAME/, out
    assert_match /DESCRIPTION/, out
    assert_match /show this help/i, out
  end
end
