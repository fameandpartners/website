namespace :reports do
  task :daily_reports => :environment do
    REPORTS_FOLDER = './tmp/reports/'

    report = ::Reports::DailyOrders.new(from: Date.today - 6.weeks, to: Date.today)

    FileUtils.mkdir_p(REPORTS_FOLDER)
    File.open(REPORTS_FOLDER + report.filename, 'w') { |file| file.write(report.report_csv) }

  end
end
