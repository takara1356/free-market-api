class Status < ApplicationRecord
  validates :status, uniqueness: true

  # 販売中のステータスIDを返す
  def self.on_sale_id
    find_by(status: 'on_sale').id
  end

  # 売り切れのステータスIDを返す
  def self.sold_out_id
    find_by(status: 'sold_out').id
  end
end
