require 'reports/order_totals'

module AdminUi
  module Reports
    class DailyOrdersController < AdminUi::Reports::StreamingCsvController

    def show
      @rows = CSV.parse(report.report_csv).map {|a| Hash[ report.en_headers.zip(a) ] }[1..10]
    end

    private

      def report
        @report ||= ::Reports::DailyOrders.new(from: from_date, to: to_date)
      end

      def report_csv
        report.report_csv
      end

      def filename
        report.filename
        # [
        #   report.description,
        #   'from',
        #   from_date.to_s(:filename),
        #   'to',
        #   to_date.to_s(:filename),
        #   'generated',
        #   DateTime.now.to_s(:filename),
        # ].join('_') << ".csv"
      end

      def from_date
        date(params[:from], default: 6.weeks.ago)
      end

      def to_date
        date(params[:to], default: Date.today)
      end

      def date(parameter, default: default)
        if parameter.present?
          Date.parse(parameter.to_s).to_date
        else
          default
        end
      rescue StandardError => e
        default
      end

    end
  end
end
