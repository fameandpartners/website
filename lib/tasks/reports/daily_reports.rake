namespace :reports do
  task :daily_reports, [:start, :duration] => [:environment] do |t, args|

    class DailyReportSender
      REPORTS_FOLDER = './tmp/reports/'

      attr_reader :start, :duration

      def initialize(start, duration)
        @start = start.to_i
        @duration = duration.to_i
      end

      def call
        create_report_folder
        save_report
        send_report
        delete_report
      end

      private

      def from
        Date.today.beginning_of_day + start.hours
      end

      def to
        from + duration.hours - 1.second
      end

      def report
        @report ||= ::Reports::DailyOrders.new(from: from, to: to, is_report: true)
      end

      def report_full_name
        REPORTS_FOLDER + report.filename
      end

      def create_report_folder
        FileUtils.mkdir_p(REPORTS_FOLDER)
      end

      def save_report
        File.open(report_full_name, 'w') { |file| file.write(report.report_csv) }
      end

      def send_report
        DailyReportMailer.email(report_full_name, report.filename, " from #{start}:00 to #{start + duration}:00").deliver
      end

      def delete_report

      end
    end

    DailyReportSender.new(args[:start], args[:duration]).call
  end
end
