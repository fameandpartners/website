set :job_template, "bash -l -c '[[ ! -f /app/tmp/STOP_CRONS ]] && :job'"
job_type :rake, "cd :path && :environment_variable=:environment /usr/local/bundle/bin/rake :task --silent :output"

set :environment, ENV['RAILS_ENV']
set :output, {:standard => '/app/log/cron_log.log', :error => '/app/log/cron_error_log.log'}

 # Fix docker env issue
ENV.each { |k, v| env(k, v) }

#every 1.day, at: '1:00 am' do
#  rake 'feed:export:all'
#end

# TODO: these reports should be migrated to RJ Metrics. Since SQL is now written on Spree, there's no need to do it now.
# all time converted to China GMT+8
#every(1.day, at: '10:00 pm') { rake '"reports:daily_reports[0, 6]"' }
#every(1.day, at: '12:00 am') { rake '"reports:daily_reports[6, 2]"' }
#every(1.day, at: '2:00 am')  { rake '"reports:daily_reports[8, 2]"' }
#every(1.day, at: '4:00 am')  { rake '"reports:daily_reports[10, 2]"' }
#every(1.day, at: '6:00 am')  { rake '"reports:daily_reports[12, 2]"' }
#every(1.day, at: '8:00 am')  { rake '"reports:daily_reports[14, 2]"' }
#every(1.day, at: '10:00 am') { rake '"reports:daily_reports[16, 2]"' }
#every(1.day, at: '12:00 pm') { rake '"reports:daily_reports[18, 2]"' }
#every(1.day, at: '2:00 pm')  { rake '"reports:daily_reports[20, 2]"' }
#every(1.day, at: '4:00 pm')  { rake '"reports:daily_reports[22, 2]"' }

# Bergen scheduled tasks

#every(30.minutes) { rake 'bergen:workers:verify_style_masters' }
#every(30.minutes) { rake 'bergen:workers:update_tracking_numbers' }
#every(30.minutes) { rake 'bergen:workers:create_asns' }
#every(3.hours)    { rake 'bergen:workers:receive_asns' }
# every(2.hours)    { runner 'Facebook::FacebookSync.delay.sync_last_28_days' }

# Next Logistics scheduled tasks

#every(30.minutes) { rake 'next:workers:asn_file_upload' }

# Refulfillment and batching
#every(15.minutes) { rake 'data:refulfill_items' }
#every(5.minutes) { rake 'data:batch_items' }
#every(1.hour) { rake 'data:groom_batches'}

# Newgistics scheduled tasks
#every(1.day) {
#  rake 'newgistics:upload_product_list' #Master file
  #rake 'newgistics:upload_return_list'  #External Orders file
#  rake 'newgistics:update_item_returns' #API for Inbound Returns
#}
#every(10.minutes) {
  rake 'newgistics:upload_return_list'  #External Orders file
#}

#every(1.week) {
#  rake 'newgistics:upload_order_list' } #Order file that needs to be shipped out by Newgistics; not needed yet
#}
