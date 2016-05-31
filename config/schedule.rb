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

every(1.day, at: '6:00 am') { rake 'reports:daily_reports[0, 6]' }
every(1.day, at: '8:00 am') { rake 'reports:daily_reports[6, 2]' }
every(1.day, at: '10:00 am') { rake 'reports:daily_reports[8, 2]' }
every(1.day, at: '12:00 pm') { rake 'reports:daily_reports[10, 2]' }
every(1.day, at: '2:00 pm') { rake 'reports:daily_reports[12, 2]' }
every(1.day, at: '4:00 pm') { rake 'reports:daily_reports[14, 2]' }
every(1.day, at: '6:00 pm') { rake 'reports:daily_reports[16, 2]' }
every(1.day, at: '8:00 pm') { rake 'reports:daily_reports[18, 2]' }
every(1.day, at: '10:00 pm') { rake 'reports:daily_reports[20, 2]' }
every(1.day, at: '12:00 pm') { rake 'reports:daily_reports[22, 2]' }
