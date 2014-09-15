require_relative 'test_helper'

class FileManagerTest < MiniTest::Unit::TestCase
  def setup
    @file_manager = Movetube::FileManager.new
  end

  def test_attr_accessors
    assert_respond_to @file_manager, :options
    assert_respond_to @file_manager, :options=
    assert_respond_to @file_manager, :source_dirs
    assert_respond_to @file_manager, :source_dirs=
    assert_respond_to @file_manager, :dest_dir
    assert_respond_to @file_manager, :dest_dir=
  end

  # Sorry, I have to test a bunch of private methods :(

  def test_private_dest_dir_for
    episode = Movetube::Node.new('Archer - s01e01.mkv')
    @file_manager.dest_dir = '/tmp'
    expected = File.join('/', 'tmp', 'Archer', 'Season 1')
    result = @file_manager.send(:dest_dir_for, episode)

    assert_instance_of Pathname, result
    assert_equal expected, result.to_s
  end
end
