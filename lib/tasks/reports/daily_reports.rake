namespace :reports do
  task :daily_reports, [:start, :duration] => [:environment] do |t, args|

    class DailyReportSender

      attr_reader :start, :duration

      def initialize(start, duration)
        @start = start.to_i
        @duration = duration.to_i
      end

      def call
        save_report
        send_report
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

      def file
        @file ||= Tempfile.new('report')
      end

      def save_report
        file.write(report.report_csv)
      end

      def send_report
        DailyReportMailer.email(file, report.filename, " from #{start}:00 to #{start + duration}:00").deliver
      end

    end

    DailyReportSender.new(args[:start], args[:duration]).call
  end
end
