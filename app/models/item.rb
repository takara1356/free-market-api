class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { only_integer: true }
  # メルカリに併せて最低出品金額を300円と想定しています
  validates :price, numericality: { greater_than_or_equal_to: 300, }

  has_one :user_item
  has_one :user, through: :user_items
end
