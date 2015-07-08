module AdminUi
  module Reports
    class PaymentsController < AdminUi::Reports::StreamingCsvController

      private

      def filename
        "payments_up_to_#{DateTime.now.to_s(:filename)}.csv"
      end

      def report
        ::Reports::Payments.new
      end
    end
  end
end
