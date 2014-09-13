require_relative 'test_helper'

class ParserTest < MiniTest::Unit::TestCase
  def setup
    hashes = TestHelpers.parsable
    @parsable = hashes['episodes'].keys + hashes['subtitles'].keys
    @non_parsable = TestHelpers.non_parsable
  end

  def test_parsable
    @parsable.each do |filename|
      assert Movetube::Parser.parsable?(filename), "#{filename} is not parsable"
    end

    @non_parsable.each do |name|
      assert !Movetube::Parser.parsable?(name), "#{name} shouldn't be parsable"
    end
  end

  def test_parse_returns_an_hash_with_predefined_keys
    (@parsable + @non_parsable).each do |filename|
      parsed = Movetube::Parser.parse(filename)
      assert_instance_of Hash, parsed
      %i(show season episode extension).each { |k| assert parsed.has_key?(k) }
    end
  end
end
