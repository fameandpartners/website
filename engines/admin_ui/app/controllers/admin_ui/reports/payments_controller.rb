module AdminUi
  module Reports
    class PaymentsController < AdminUi::Reports::StreamingCsvController

      private

      def filename
        "payments_up_to_#{DateTime.now.to_s(:filename)}.csv"
      end

      def from_date
        date(params[:from], default: 3.months.ago)
      end

      def to_date
        date(params[:to], default: Date.today)
      end

      def report
        ::Reports::Payments.new(from: from_date, to: to_date)
      end

      def date(parameter, default:)
        if parameter.present?
          Date.parse(parameter.to_s)
        else
          default
        end
      rescue ArgumentError
        default
      end

    end
  end
end
