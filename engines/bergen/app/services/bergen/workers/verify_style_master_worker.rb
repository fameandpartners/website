require 'sidekiq'

module Bergen
  module Workers
    class VerifyStyleMasterWorker < BaseWorker
      VERIFY_AGAIN_INTERVAL = 30.minutes

      # Don't exists
      # Created
      # Pending

      def perform(return_item_process_id)
        return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        return_request_item = return_item_process.return_request_item

        if style_master_exists?(return_request_item)
          return_item_process.guarantee_style_master!
          return_item_process.create_asn
        else
          bergen.style_master_product_add_by_return_request_items(return_request_items: [return_request_item])
          self.class.perform_in(VERIFY_AGAIN_INTERVAL, return_item_process_id)
        end
      end

      private

      def style_master_exists?(return_request_item)
        result = bergen.get_style_master_product_add_status_by_return_request_item(return_request_item: return_request_item)
        result[:severity] == 'Success'
      end

      def bergen
        Bergen::Service.new
      end
    end
  end
end
