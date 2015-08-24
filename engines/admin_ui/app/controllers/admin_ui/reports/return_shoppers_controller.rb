module AdminUi
  module Reports
    class ReturnShoppersController < AdminUi::Reports::StreamingCsvController

      private

      def filename
        "return_shoppers_#{DateTime.now.to_s(:filename)}.csv"
      end

      def report
        ::Reports::ReturnShoppers.new
      end
    end
  end
end
