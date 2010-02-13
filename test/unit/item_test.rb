require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "name and description required" do
    item = Item.new
    assert !item.valid?
    assert item.errors.invalid?(:name)
    assert item.errors.invalid?(:description)
  end

  test "unique name required" do
    # Fixture :collings_om1 named "Collings OM1"
    assert_equal "Collings OM1", items(:collings_om1).name
    item = Item.new(:name => "Collings OM1", :description => "descr...")
    assert !item.save
    assert item.errors.invalid?(:name)
    assert_equal $default_errors[:taken], item.errors.on(:name)
  end

  test "cross sale group not empty" do
    # Fixture :collings_om1 has associated :acoustics csg
    assert !items(:collings_om1).cross_sale_groups.empty?
  end

  test "cross sale group empty" do
    # Fixture :humidifier has no associated csg
    assert items(:humidifier).cross_sale_groups.empty?
  end

  test "valid item saves" do
    item = Item.new(:name => "My Item", :description => "Descr...")
    assert item.valid?
    assert item.save
    assert_respond_to(item, :name)
    assert_respond_to(item, :description)
  end
end
