require 'sidekiq'

module Bergen
  module Workers
    class ReceiveAsnWorker < BaseWorker
      VERIFY_AGAIN_INTERVAL = 3.hours

      attr_reader :return_request_item, :return_item_process

      def perform(return_item_process_id)
        @return_item_process = Operations::ReturnItemProcess.find(return_item_process_id)
        @return_request_item = return_item_process.return_request_item

        if item_was_received?
          mark_asn_as_received
        else
          verify_again_in_few_hours
        end
      end

      private

      def verify_again_in_few_hours
        self.class.perform_in(VERIFY_AGAIN_INTERVAL, return_item_process.id)
      end

      def mark_asn_as_received
        return_item_process.asn_was_received!
        return_request_item.item_return.events.bergen_asn_received.create(bergen_attributes)
      end

      def bergen_attributes
        response     = bergen_ticket_response
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
          memo:                    '', # TODO: do Bergen offer a memo field on response?
          receiving_status:        response[:receiving_status],
          receiving_status_code:   response[:receiving_status_code],
          warehouse:               response[:warehouse],
        }
      end

      def item_was_received?
        bergen_ticket_response[:receiving_status] == 'AddedToInventory'
      end

      def bergen_ticket_response
        Bergen::Service.new.get_receiving_ticket_object_by_ticket_no(return_request_item: return_request_item)
      end
    end
  end
end
