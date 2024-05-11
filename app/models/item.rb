class Item < ApplicationRecord
  validates :name, :mainclass, :subclass, :price, presence: true
  validates :amount_purchased, numericality: { greater_than_or_equal_to: 0 }
end
