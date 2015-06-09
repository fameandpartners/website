namespace :reports do
  desc 'payments by order'
  task :payments_by_order => :environment do
    PaymentsReport.new.report
  end
end
