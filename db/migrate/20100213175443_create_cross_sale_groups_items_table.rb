class CreateCrossSaleGroupsItemsTable < ActiveRecord::Migration
  def self.up
    create_table :cross_sale_groups_items, :id => false do |t|
      t.integer :cross_sale_group_id
      t.integer :item_id
    end
  end

  def self.down
    drop_table :cross_sale_groups_items
  end
end
