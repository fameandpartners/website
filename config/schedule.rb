set :environment, ENV['RAILS_ENV']

every 4.hours do
  runner 'EmailMarketing.send_emails'
  # runner 'StockInvent::Runner.run'
end

every 1.day, at: '5:00 am' do
  rake 'sitemap:create', output: { error: 'log/sitemap_error.log', standard: 'log/sitemap.log' }
end

every 1.day, at: '1:00 am' do
  rake 'feed:export:all'
end
