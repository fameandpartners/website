set :environment, ENV['RAILS_ENV']

every 4.hours do
  runner 'EmailMarketing.send_emails'
  rake   'feed:export:all'

  runner 'StockInvent::Runner.run'
end

every 1.day, :at => '5:00 am' do
  rake "sitemap:create", :output => { :error => 'log/sitemap_error.log', :standard => 'log/sitemap.log' }
end

# TODO - 2015.05.22 - Enable this once we have run it a few times manually in production. SOYOLO
# every 1.day, :at => '4:00 am' do
#   rake "data:clean", :output => { :error => 'log/data_clean_error.log', :standard => 'log/data_clean.log' }
# end
