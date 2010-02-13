class CreateCrossSaleGroups < ActiveRecord::Migration
  def self.up
    create_table :cross_sale_groups do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :cross_sale_groups
  end
end
