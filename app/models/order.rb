class Order < ApplicationRecord
  belongs_to :purchased_user, class_name: 'User', foreign_key: :purchased_user_id
  belongs_to :item
end
