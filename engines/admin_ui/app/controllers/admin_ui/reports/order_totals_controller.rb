require 'reports/order_totals'

module AdminUi
  module Reports
    class OrderTotalsController < AdminUi::Reports::StreamingCsvController

      private

      def report
        ::Reports::OrderTotals.new
      end

      def filename
        [
          report.description,
          'generated',
          DateTime.now.to_s(:filename),
        ].join('_') << ".csv"
      end
    end
  end
end
