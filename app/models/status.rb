class Status < ApplicationRecord

  def self.on_sale_id
    find_by(status: 'on_sale').id
  end
end
