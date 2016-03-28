# Note that this uses the Savon 1.2 API.

module Bergen
  class Service
    attr_reader :client

    def initialize
      @client = SavonClient.new
    end

    def get_inventory
      SoapMethods::GetInventory.new(
        savon_client: client
      ).request
    end

    def receiving_ticket_add(return_request_item)
      SoapMethods::ReceivingTicketAdd.new(
        savon_client:        client,
        return_request_item: return_request_item
      ).request
    end

    def get_receiving_ticket_object_by_ticket_no
      # TODO
    end

    def style_master_product_add(return_request_item)
      SoapMethods::StyleMasterProductAdd.new(
        savon_client:        client,
        return_request_item: return_request_item
      ).request
    end

    def get_style_master_product_add_status(return_request_item)
      SoapMethods::GetStyleMasterProductAddStatus.new(
        savon_client:        client,
        return_request_item: return_request_item
      ).request
    end
  end
end
