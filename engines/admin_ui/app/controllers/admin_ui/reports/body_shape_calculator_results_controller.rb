module AdminUi
  module Reports
    class BodyShapeCalculatorResultsController < AdminUi::Reports::StreamingCsvController
      include AdminUi::Reports::Concerns::DateParamCoercer

      private

      def report
        ::Reports::BodyShapeCalculatorResults.new(from: from_date, to: to_date)
      end

      def filename
        [
            report.description,
            'from',
            from_date.to_s(:filename),
            'to',
            to_date.to_s(:filename),
            'generated',
            DateTime.now.to_s(:filename),
        ].join('_') << '.csv'
      end
    end
  end
end
