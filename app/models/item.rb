class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { only_integer: true }
  # メルカリに合わせて最低出品金額を300円と想定しています
  validates :price, numericality: { greater_than_or_equal_to: 300, }

  has_one :user_item, dependent: :destroy
  has_one :user, through: :user_items
  has_one :order

  def update_status_to_sold_out
    self.update(status_id: Status.sold_out_id)
  end
end
