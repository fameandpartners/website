require 'sidekiq'

module Bergen
  module Workers
    class CreateAsnWorker < BaseWorker
      attr_reader :return_request_item, :return_item_process

      def perform(return_item_process_id)
        @return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        @return_request_item = return_item_process.return_request_item

        label = Shippo::Label.new(@return_request_item).create      # Create Shippo return label
        update_tracking_number(label[:tracking_number])             # Update tracking number in the line_item shipment
        asn_number = create_asn(label[:tracking_number])            # Create ASN
        create_asn_retrieval_event(asn_number, label[:label_url])   # Save Bergen Ticket Number on Item Request Return
        advance_in_return_item_process                              # Continue

        @return_item_process.touch
      rescue StandardError => e
        sentry_error = Raven.capture_exception(e)
        @return_item_process.update_column(:sentry_id, sentry_error.id)
        @return_item_process.update_column(:failed, true)
      end

      private

      def create_asn_retrieval_event(asn_number, shippo_label)
        return_request_item.item_return.events.bergen_asn_created.create(
          asn_number: asn_number,
          shippo_label: shippo_label
        )
      end

      def advance_in_return_item_process
        return_item_process.asn_was_created!
      end

      def create_asn(tracking_number)
        result = bergen.receiving_ticket_add(
          return_request_item: return_request_item,
          tracking_number: tracking_number
        )
        result[:receiving_ticket_id]
      end

      def update_tracking_number(tracking_number)
        order = return_request_item.line_item.order
        shipments = order.shipments.select do |shipment|
          shipment.line_items.any? {|line_item| line_item.id == return_request_item.line_item.id}
        end

        shipments.each do |shipment|
          shipment.tracking = tracking_number
          shipment.save
        end
      end

      def bergen
        Bergen::Service.new
      end
    end
  end
end
