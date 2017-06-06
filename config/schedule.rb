set :job_template, "bash -l -c '[[ ! -f /tmp/STOP_CRONS ]] && . /etc/app_description && . $APP_LOCATION/shared/envvars && :job'"
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

# TODO: these reports should be migrated to RJ Metrics. Since SQL is now written on Spree, there's no need to do it now.
# all time converted to China GMT+8
every(1.day, at: '10:00 pm') { rake '"reports:daily_reports[0, 6]"' }
every(1.day, at: '12:00 am') { rake '"reports:daily_reports[6, 2]"' }
every(1.day, at: '2:00 am')  { rake '"reports:daily_reports[8, 2]"' }
every(1.day, at: '4:00 am')  { rake '"reports:daily_reports[10, 2]"' }
every(1.day, at: '6:00 am')  { rake '"reports:daily_reports[12, 2]"' }
every(1.day, at: '8:00 am')  { rake '"reports:daily_reports[14, 2]"' }
every(1.day, at: '10:00 am') { rake '"reports:daily_reports[16, 2]"' }
every(1.day, at: '12:00 pm') { rake '"reports:daily_reports[18, 2]"' }
every(1.day, at: '2:00 pm')  { rake '"reports:daily_reports[20, 2]"' }
every(1.day, at: '4:00 pm')  { rake '"reports:daily_reports[22, 2]"' }

# Bergen scheduled tasks

every(30.minutes) { rake 'bergen:workers:verify_style_masters' }
every(30.minutes) { rake 'bergen:workers:update_tracking_numbers' }
every(30.minutes) { rake 'bergen:workers:create_asns' }
every(3.hours)    { rake 'bergen:workers:receive_asns' }
every(1.hours)    { rake 'facebook_ads:sync' }

# Next Logistics scheduled tasks

every(30.minutes) { rake 'next:workers:asn_file_upload' }


