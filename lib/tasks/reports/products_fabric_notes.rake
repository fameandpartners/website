namespace :reports do
  desc 'payments by order'
  task :product_fabric_notes => :environment do
    report = Reports::ProductFabricNotes.new
    report.to_csv_rows.each { |row| puts row }
  end
end
