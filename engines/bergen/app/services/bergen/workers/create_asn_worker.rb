require 'sidekiq'

module Bergen
  module Workers
    class CreateAsnWorker < BaseWorker
      attr_reader :return_request_item, :return_item_process

      def perform(return_item_process_id)
        @return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        @return_request_item = return_item_process.return_request_item

        asn_number = create_asn                # Create ASN
        create_asn_retrieval_event(asn_number) # Save Bergen Ticket Number on Item Request Return
        advance_in_return_item_process         # Continue

        @return_item_process.touch
      rescue StandardError => e
        sentry_error = Raven.capture_exception(e)
        @return_item_process.update_column(:sentry_id, sentry_error.id)
        @return_item_process.update_column(:failed, true)
      end

      private

      def create_asn_retrieval_event(asn_number)
        return_request_item.item_return.events.bergen_asn_created.create(asn_number: asn_number)
      end

      def advance_in_return_item_process
        return_item_process.asn_was_created!
      end

      def create_asn
        result = bergen.receiving_ticket_add(return_request_item: return_request_item)
        result[:receiving_ticket_id]
      end

      def bergen
        Bergen::Service.new
      end
    end
  end
end
