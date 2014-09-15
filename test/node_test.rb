require_relative 'test_helper'

class NoteTest < MiniTest::Unit::TestCase
  def setup
    @parsable_episodes = TestHelpers.parsable['episodes']
    @parsable_subtitles = TestHelpers.parsable['subtitles']
  end

  def test_episodes_and_subtitles_are_different
    assert_all(keys_to_nodes(@parsable_episodes), &:episode?)
    assert_all(keys_to_nodes(@parsable_subtitles), &:subtitle?)
  end

  def test_all_valid_nodes_are_valid
    all = keys_to_nodes(@parsable_episodes) + keys_to_nodes(@parsable_subtitles)
    assert_all(all, &:valid?)
  end

  def test_parsable_strings_are_parsed_correctly
    @parsable_episodes.each do |filename, data|
      episode = Movetube::Node.new(filename)
      assert_metadata data, episode
    end

    @parsable_subtitles.each do |filename, data|
      subtitle = Movetube::Node.new(filename)
      assert_metadata data, subtitle
    end
  end

  def test_language_setter
    episode = keys_to_nodes(@parsable_episodes).first
    assert_nil episode.language
    assert_raises(Movetube::NotASubtitleError) { episode.language = 'foo' }

    subtitle = keys_to_nodes(@parsable_subtitles).first
    assert_nil subtitle.language
    subtitle.language = 'foo'
    assert_equal 'foo', subtitle.language
  end

  def test_format
    @parsable_episodes.each do |filename, data|
      episode = Movetube::Node.new(filename)
      assert_equal data['formatted'], episode.format
    end

    @parsable_subtitles.each do |filename, data|
      subtitle = Movetube::Node.new(filename)
      subtitle.language = data['_language']
      assert_equal data['formatted'], subtitle.format
    end
  end

  private

  def assert_metadata(data, node)
    assert_equal data['show'], node.show, 'show'
    assert_equal data['season'], node.season, 'season'
    assert_equal data['episode'], node.episode, 'episode'
    assert_equal data['extension'], node.extension, 'extension'
  end

  def keys_to_nodes(dict)
    dict.keys.map { |k| Movetube::Node.new(k) }
  end
end
