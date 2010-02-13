require 'test_helper'

class CrossSaleGroupTest < ActiveSupport::TestCase
  test "name required" do
    csg = CrossSaleGroup.new
    assert !csg.valid?
    assert csg.errors.invalid?(:name)
  end

  test "unique name required" do
    csg1 = CrossSaleGroup.new(:name => "My Group")
    assert csg1.save
    csg2 = CrossSaleGroup.new(:name => "My Group")
    assert !csg2.save
    assert csg2.errors.invalid?(:name)
    assert_equal $default_errors[:taken], csg2.errors.on(:name)
  end
end
