require 'test_helper'

class CrossSaleGroupTest < ActiveSupport::TestCase
  test "name required" do
    csg = CrossSaleGroup.new
    assert !csg.valid?
    assert csg.errors.invalid?(:name)
  end

  test "unique name required" do
    # Fixture :acoustics named "Acoustics"
    assert_equal "Acoustics", cross_sale_groups(:acoustics).name
    csg = CrossSaleGroup.new(:name => "Acoustics")
    assert !csg.save
    assert csg.errors.invalid?(:name)
    assert_equal $default_errors[:taken], csg.errors.on(:name)
  end

  test "has associated items" do
    # Fixture :acoustics has items
    assert !cross_sale_groups(:acoustics).items.empty?
  end

  test "has no associated items" do
    csg = CrossSaleGroup.new(:name => "My CSG")
    assert csg.items.empty?
  end

  test "valid cross sale group saves" do
    csg = CrossSaleGroup.new(:name => "My CSG")
    assert csg.valid?
    assert csg.save
    assert_respond_to(csg, :name)
  end
end
