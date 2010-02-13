class Item < ActiveRecord::Base
  has_and_belongs_to_many :cross_sale_groups
  validates_presence_of   :name, :description
  validates_uniqueness_of :name
end
