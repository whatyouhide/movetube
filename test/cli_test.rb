require_relative 'test_helper'

class CLITest < MiniTest::Unit::TestCase
  def test_responds_to_the_run_method
    assert_respond_to Movetube::CLI, :run
  end

  def test_help_works
    out, err = capture_subprocess_io do
      success = system 'bin/movetube --help'
      assert success, 'the bin/movetube command failed'
    end

    assert_empty err
    assert_is_help_message out
  end

  def test_shows_help_when_no_argument_is_passed
    out, err = capture_subprocess_io do
      success = system 'bin/movetube'
      assert success, 'the bin/movetube command failed'
    end

    assert_empty err
    assert_is_help_message out
  end

  def test_verbose_flag
    out, err = capture_io do
      run_with_argv ['foo', '--no-verbose', '--dest', 'bar']
      refute Movetube.config.verbose

      run_with_argv ['foo', '--dest', 'bar']
      assert Movetube.config.verbose
    end
  end

  def test_error_if_no_destination_dir
    backup_and_remove_config_file
    out, err = capture_subprocess_io do
      success = system 'bin/movetube ./srcdir'
      refute success
    end
    recreate_config_file

    assert_empty out
    assert_match /no destination dir/i, err
  end

  private

  def assert_is_help_message(output)
    assert_match /name/i, output
    assert_match /usage/i, output
    assert_match /description/i, output
    assert_match /help/i, output
  end

  # Run the cli app with the given array of arguments.
  def run_with_argv(argv)
    Movetube::CLI.run(argv)
  end

  # Execute the given block setting Movetube.config_file to `path`. Reset it
  # back to its original value after executing the block.
  def run_with_config_file(path, &block)
    old_path = Movetube.config_file
    Movetube.config_file = path
    yield
    Movetube.config_file = old_path
  end

  def backup_and_remove_config_file
    return unless File.exist?(Movetube.config_file)
    @config_contents = File.read(Movetube.config_file)
    File.delete(Movetube.config_file)
  end

  def recreate_config_file
    File.write(Movetube.config_file, @config_contents)
  end
end
