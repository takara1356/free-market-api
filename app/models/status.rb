class Status < ApplicationRecord
  validates :status, uniqueness: true

  def self.on_sale_id
    find_by(status: 'on_sale').id
  end

  def self.sold_out_id
    find_by(status: 'sold_out').id
  end
end
