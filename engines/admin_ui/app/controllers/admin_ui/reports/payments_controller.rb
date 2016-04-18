module AdminUi
  module Reports
    class PaymentsController < AdminUi::Reports::StreamingCsvController
      include AdminUi::Reports::Concerns::DateParamCoercer

      private

      def filename
        "payments_up_to_#{DateTime.now.to_s(:filename)}.csv"
      end

      def report
        ::Reports::Payments.new(from: from_date, to: to_date)
      end
    end
  end
end
