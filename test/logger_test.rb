require_relative 'test_helper'

class LoggerTest < MiniTest::Unit::TestCase
  def test_print
    out, err = capture_io { std_logger.print 'printing' }
    assert_match /printing/, out
    assert_empty err
  end

  def test_success
    msg = 'foo bar success'
    out, err = capture_io { std_logger.success(msg) }
    assert_match /#{msg}/, out
    assert_empty err
  end

  def test_error
    msg = 'foo bar error'
    out, err = capture_io { std_logger.error(msg) }
    assert_empty out
    assert_match /#{msg}/, err
  end

  def test_warning
    msg = 'foo bar warning'
    out, err = capture_io { std_logger.warning(msg) }
    assert_empty err
    assert_match /#{msg}/, out
  end

  def test_a_different_io_can_be_used
    io = StringIO.new
    logger = Movetube::Logger.new(io, io)

    # Nothing is output to the standard out/err.
    assert_silent do
      logger.success 'success'
      logger.error 'error'
    end

    refute_empty io.string
    assert_match /success/, io.string
    assert_match /error/, io.string
  end

  def test_silent_mode
    out, err = capture_io do
      logger = std_logger.tap { |l| l.silence! }
      logger.print 'hello'
      logger.success 'oh no!'
      logger.warning 'meh'
      logger.error 'hola amigo'
    end

    assert_empty out
    assert_match /hola amigo/, err
  end

  private

  # I have to create a logger dynamically (and not in the `setup` method) in
  # order to be able to create in inside calls to `capture_io`, which changes
  # $stdout and $stderr *after* the logger has been bound to the old ones.
  def std_logger
    Movetube::Logger.new
  end
end
