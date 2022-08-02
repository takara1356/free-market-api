require 'csv'

CSV.foreach('db/seed_csv/statuses.csv') do |r|
  puts "create status: #{r[0]}"
  Status.create!(
    status: r[0]
  )
end
