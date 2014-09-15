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
end
