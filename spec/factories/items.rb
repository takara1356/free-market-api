FactoryBot.define do
  factory :item do
    name { 'SQLアンチパターン 第2版' }
    description { '特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。' }
    price { 1000 }
    status_id { Status.on_sale_id }
  end
end
