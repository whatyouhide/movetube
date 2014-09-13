require 'minitest/autorun'
require 'minitest/pride'
require 'yaml'

require 'movetube'

class TestHelpers
  def self.parsable
    @parsable ||= YAML.load_file('test/parsable.yml')
  end

  def self.non_parsable
    @non_parsable ||= YAML.load_file('test/non_parsable.yml')
  end
end

class MiniTest::Unit::TestCase
  # Assert that `&block` is `true` for all elements of `ary`.
  def assert_all(ary, &block)
    assert(ary.map { |el| block.call(el) }.all?)
  end
end
