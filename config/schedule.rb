every :hour do
  runner 'EmailMarketing.send_emails'
  rake   'feed:export:all'

  runner 'BridesmaidPartyEmailMarketing.send_emails'

  runner 'StockInvent::Runner.run'
end

every 1.day, :at => '5:00 am' do
  rake "sitemap:create", :output => { :error => 'log/sitemap_error.log', :standard => 'log/sitemap.log' }
end
