namespace :reports do
  desc 'payments by order'
  task :payments_by_order => :environment do
    Reports::Payments.new.report
  end
end
