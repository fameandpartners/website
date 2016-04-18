module AdminUi
  module Reports
    class BergenReturnsController < AdminUi::Reports::StreamingCsvController
      include AdminUi::Reports::Concerns::DateParamCoercer

      private

      def filename
        "bergen_returns_#{DateTime.now.to_s(:filename)}.csv"
      end

      def report
        ::Reports::BergenReturns.new(from: from_date, to: to_date)
      end
    end
  end
end
