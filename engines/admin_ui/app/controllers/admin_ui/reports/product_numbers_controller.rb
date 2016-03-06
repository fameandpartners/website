require 'reports/product_numbers'

module AdminUi
  module Reports
    class ProductNumbersController < AdminUi::Reports::StreamingCsvController

      private

      def report
        ::Reports::ProductNumbers.new
      end
    end
  end
end
