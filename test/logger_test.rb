require_relative 'test_helper'

class LoggerTest < MiniTest::Unit::TestCase
  def setup
    @logger = Movetube::Logger
  end

  def test_success
    msg = 'foo bar success'

    out, err = capture_io { @logger.success(msg) }

    assert_match /#{msg}/, out
    assert_empty err
  end

  def test_error
    msg = 'foo bar error'

    out, err = capture_io { @logger.error(msg) }

    assert_empty out
    assert_match /#{msg}/, err
  end

  def test_a_different_io_can_be_used
    io = StringIO.new

    # Nothing is output to the standard out/err.
    assert_silent do
      @logger.success('success', io)
      @logger.error('error', io)
    end

    refute_empty io.string
    assert_match /success/, io.string
    assert_match /error/, io.string
  end
end
