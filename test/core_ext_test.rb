require_relative 'test_helper'

class CoreExtTest < MiniTest::Unit::TestCase
  def setup
    @hash = { a: 1, b: 2, c: 3 }
  end

  def test_hash_only_keys_with_empty_keys
    assert_empty({}.only_keys())
    assert_empty @hash.only_keys()
  end

  def test_hash_only_keys_with_all_the_keys
    assert_equal @hash, @hash.only_keys(*@hash.keys)
  end

  def test_hash_only_keys_selects_right_keys
    assert_equal({ a: 1 }, @hash.only_keys(:a))
    assert_equal({ a: 1, b: 2 }, @hash.only_keys(:a, :b))
    assert_equal({ a: 1, c: 3 }, @hash.only_keys(:a, :c))
  end

  def test_hash_only_keys_ignores_non_existing_keys
    assert_equal @hash, @hash.only_keys(:a, :b, :c, :foo)
    assert_equal({ b: 2 }, @hash.only_keys(:b, :bar))
  end
end
