set :environment, ENV['RAILS_ENV']

every :hour do
  runner 'EmailMarketing.send_emails'
  rake   'feed:export:all'

  runner 'BridesmaidPartyEmailMarketing.send_emails'

  runner 'StockInvent::Runner.run'
end

every 1.day, :at => '5:00 am' do
  rake "sitemap:create", :output => { :error => 'log/sitemap_error.log', :standard => 'log/sitemap.log' }
end

every 1.day, :at => '4:55 am' do
  rake "data:clean", :output => { :error => 'log/data_clean_error.log', :standard => 'log/data_clean.log' }
end
