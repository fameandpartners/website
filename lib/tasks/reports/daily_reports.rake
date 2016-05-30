namespace :reports do
  task :daily_reports, [:report_type] => [:environment] do |t, args|
    REPORTS_FOLDER = './tmp/reports/'\

    if args[:report_type] == 'first'
      from = Date.today.beginning_of_day
      to = from + 12.hours - 1.second
    else
      from = Date.today.beginning_of_day + 12.hours
      to = from.end_of_day
    end

    report = ::Reports::DailyOrders.new(from: from, to: to, is_report: true)
    report_full_name = REPORTS_FOLDER + report.filename

    FileUtils.mkdir_p(REPORTS_FOLDER)
    File.open(report_full_name, 'w') { |file| file.write(report.report_csv) }

    DailyReport.email(report_full_name, report.filename, args[:report_type]).deliver
  end
end
