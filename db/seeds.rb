require 'csv'

CSV.foreach('db/seed_csv/statuses.csv') do |r|
  Status.create(
    status: r[0]
  )
end
