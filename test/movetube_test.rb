require_relative 'test_helper'

class MovetubeTest < MiniTest::Unit::TestCase
  def test_has_accessible_config
    assert_respond_to Movetube, :config
    assert_respond_to Movetube, :config=
  end

  def test_config_can_be_added_anytime
    assert_nil Movetube.config.foobar
    Movetube.config.foobar = 'foobar'
    assert_equal 'foobar', Movetube.config.foobar
  end

  def test_has_accessible_config_file
    assert_respond_to Movetube, :config_file
    assert_respond_to Movetube, :config_file=
  end
end
