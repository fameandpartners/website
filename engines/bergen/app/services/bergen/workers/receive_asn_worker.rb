require 'sidekiq'

module Bergen
  module Workers
    class ReceiveAsnWorker < BaseWorker
      ADDED_TO_INVENTORY    = 'AddedToInventory'.freeze
      DRAFT                 = 'Draft'.freeze
      PENDING_PRINTING      = 'PendingPrinting'.freeze
      PRINTED_PENDING_COUNT = 'PrintedPendingCount'.freeze

      # TODO: it's possible it never leave Draft if they never receive the parcel

      attr_reader :return_request_item, :return_item_process

      def perform(return_item_process_id)
        @return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        @return_request_item = return_item_process.return_request_item

        if item_was_received?
          mark_asn_as_received
        end

        @return_item_process.touch
      rescue StandardError => e
        sentry_error = Raven.capture_exception(e)
        @return_item_process.update_column(:sentry_id, sentry_error.id) if sentry_error
        @return_item_process.update_column(:failed, true)
      end

      private

      def mark_asn_as_received
        return_item_process.asn_was_received!
        return_request_item.item_return.events.bergen_asn_received.create(bergen_attributes)
      end

      def bergen_attributes
        response     = bergen_ticket_object
        item_details = response[:shipmentitemslist]

        {
          actual_quantity:         item_details[:actual_quantity],
          color:                   item_details[:color],
          damaged_quantity:        item_details[:damaged_quantity],
          expected_quantity:       item_details[:expected_quantity],
          product_msrp:            item_details[:product_msrp],
          shipment_type:           item_details[:shipment_type],
          size:                    item_details[:size],
          style:                   item_details[:style],
          unit_cost:               item_details[:unit_cost],
          upc:                     item_details[:upc],
          added_to_inventory_date: response[:added_to_inventory_date],
          arrived_date:            response[:arrived_date],
          created_date:            response[:created_date],
          expected_date:           response[:expected_date],
          memo:                    response[:memo],
          receiving_status:        response[:receiving_status],
          receiving_status_code:   response[:receiving_status_code],
          warehouse:               response[:warehouse],
        }
      end

      def item_was_received?
        bergen_ticket_object && bergen_ticket_object[:receiving_status] == ADDED_TO_INVENTORY
      end

      def bergen_ticket_object
        @bergen_ticket_object ||= Bergen::Service.new.get_receiving_ticket_object_by_ticket_no(return_request_item: return_request_item)
      end
    end
  end
end
