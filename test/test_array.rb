require_relative "test_helper"
require "rulers/array"

class RulersArrayTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_sum
    assert_equal [].sum, 0
    assert_equal [2].sum, 2
    assert_equal [1,2,3,4].sum, 10
  end

  def test_product
    assert_equal [].product, 1
    assert_equal [2].product, 2
    assert_equal [1,2,3,4].product, 24
  end
end
