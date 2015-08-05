require 'reports/sale_items'

module AdminUi
  module Reports
    class SaleItemsController < AdminUi::Reports::StreamingCsvController

      private

      def report
        ::Reports::SaleItems.new(from: from_date, to: to_date)
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
        ].join('_') << ".csv"
      end

      # lol programming
      def from_date
        date(params[:from], default: 1.month.ago)
      end

      def to_date
        date(params[:to], default: Date.today)
      end

      def date(parameter, default: )
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
