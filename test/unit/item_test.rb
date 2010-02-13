require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "name and description required" do
    item = Item.new
    assert !item.valid?
    assert item.errors.invalid?(:name)
    assert item.errors.invalid?(:description)
  end

  test "unique name required" do
    item1 = Item.new(:name => "My Item", :description => "descr...")
    assert item1.save
    item2 = Item.new(:name => "My Item", :description => "descr...")
    assert !item2.save
    assert item2.errors.invalid?(:name)
    assert_equal $default_errors[:taken], item2.errors.on(:name)
  end
end
