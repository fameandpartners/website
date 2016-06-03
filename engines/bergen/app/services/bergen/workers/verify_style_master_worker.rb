require 'sidekiq'

module Bergen
  module Workers
    class VerifyStyleMasterWorker < BaseWorker
      VERIFY_AGAIN_INTERVAL = 30.minutes

      # TODO: probably these messages shouldn't live here, but live inside one of the soap methods
      # TODO: but we have two for getting status: return items + variants.
      ERROR                 = 'Error'.freeze # indicates that product add failed;
      PENDING_IMPORT        = 'PendingImport'.freeze # indicates that product add is pending import;
      SUCCESS               = 'Success'.freeze # indicates that product add was successful.
      UPC_CODE_ERROR        = 'UpcCodeError'.freeze # the UPC for which add status is requested was not found;

      attr_reader :return_item_process, :return_request_item

      def perform(return_item_process_id)
        @return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        @return_request_item = return_item_process.return_request_item

        case style_master_status
          when SUCCESS
            advance_in_return_item_process
          when UPC_CODE_ERROR
            create_style_master
            verify_again_in_few_minutes
          when PENDING_IMPORT
            verify_again_in_few_minutes
          else
            # TODO: Error handling
        end
      end

      private

      def advance_in_return_item_process
        return_item_process.style_master_was_created!
        return_item_process.create_asn
      end

      def create_style_master
        bergen.style_master_product_add_by_return_request_items(return_request_items: [return_request_item])
      end

      def verify_again_in_few_minutes
        self.class.perform_in(VERIFY_AGAIN_INTERVAL, return_item_process.id)
      end

      def style_master_status
        result = bergen.get_style_master_product_add_status_by_return_request_item(return_request_item: return_request_item)
        result[:severity]
      end

      def bergen
        Bergen::Service.new
      end
    end
  end
end
