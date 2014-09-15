require_relative 'test_helper'
require 'tempfile'

class FileOperatorTest < MiniTest::Unit::TestCase
  # `@tmp_dir` is an instance of Pathname.

  def setup
    @existing_tmpdir = Pathname.new(Dir.mktmpdir)
    @nonexisting_tmpdir = Pathname.new(Dir.tmpdir) + 'mtb' + rand(1000000).to_s

    @existing_tempfile = Pathname.new(Tempfile.new('foo').path)
  end

  def teardown
    @existing_tmpdir.delete
    @existing_tempfile.delete if @existing_tempfile.exist?
  end

  def test_mkpath_doesnt_do_anything_if_the_directory_already_exists
    out, err = capture_io { wet.mkpath(@existing_tmpdir) }
    assert_empty out
    assert_empty err
  end

  def test_mkpath_with_dry_run_on
    out, err = capture_io { dry.mkpath(@nonexisting_tmpdir) }

    assert_empty err
    assert_match /would create directory/i, out
    assert_contains @nonexisting_tmpdir.to_s, out

    # No directory has actually been created.
    refute @nonexisting_tmpdir.exist?
  end

  def test_mkpath_with_dry_run_off
    out, err = capture_io { wet.mkpath(@nonexisting_tmpdir) }

    assert_empty err
    assert_match /created directory/i, out
    assert_contains @nonexisting_tmpdir.to_s, out
    assert_predicate @nonexisting_tmpdir, :exist?
  end

  def test_rename_fails_when_the_source_file_doesnt_exist
    assert_raises(Errno::ENOENT) do
      wet.rename(Pathname.new('/impossiblefoo'), 'notachance')
    end
  end

  def test_rename_with_dry_run_on
    new_path = @existing_tempfile.dirname + 'foo'
    out, err = capture_io { dry.rename(@existing_tempfile, 'foo') }

    assert_empty err
    assert_match /would rename/i, out
    assert_contains @existing_tempfile.to_s, out
    assert_contains new_path.to_s, out

    # No modifications have actually been made.
    assert_predicate @existing_tempfile, :exist?
    refute_predicate new_path, :exist?
  end

  def test_rename_with_dry_run_off
    new_path = @existing_tempfile.dirname + 'bar'
    out, err = capture_io { wet.rename(@existing_tempfile, 'bar') }

    assert_empty err
    assert_match /renamed/i, out
    assert_contains @existing_tempfile.to_s, out
    assert_contains new_path.to_s, out

    # Check that actual modifications have been made.
    assert_predicate new_path, :exist?
    refute_predicate @existing_tempfile, :exist?

    # Ensure the new path is deleted.
    new_path.delete
  end

  def test_move_fails_when_the_source_file_doesnt_exist
    assert_raises(Errno::ENOENT) do
      capture_io do
        wet.move(
          Pathname.new('/trust-me-it-doesnt-exist'),
          Pathname.new('/i-toldja')
        )
      end
    end
  end

  def test_move_fails_when_the_destination_directory_doesnt_exist
    assert_raises(Errno::ENOENT) do
      capture_io do
        wet.move(
          Pathname.new(Tempfile.new('bar').path),
          Pathname.new("/wow-this-doesnt-exist#{rand(1000000)}/foo")
        )
      end
    end
  end

  def test_move_with_dry_run_on
    new_file = @existing_tmpdir + @existing_tempfile.basename.to_s
    out, err = capture_io do
      dry.move(@existing_tempfile, new_file)
    end

    assert_empty err
    assert_match /would move/i, out

    assert_predicate @existing_tempfile, :exist?
    refute_predicate new_file, :exist?
  end

  def test_move_with_dry_run_off
    new_file = @existing_tmpdir + @existing_tempfile.basename.to_s
    out, err = capture_io do
      wet.move(@existing_tempfile, new_file)
    end

    assert_empty err
    assert_match /moving\.{3}/i, out
    assert_match /moved/i, out

    refute_predicate @existing_tempfile, :exist?
    assert_predicate new_file, :exist?

    # Manually destroy this newly created file (directory not empty otherwise).
    new_file.delete
  end

  private

  def dry
    # Dry run mode is on by default.
    Movetube::FileOperator.new
  end

  def wet
    Movetube::FileOperator.new dry_run: false
  end
end
