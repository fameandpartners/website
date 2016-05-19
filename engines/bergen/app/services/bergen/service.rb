module Bergen
  class Service
    attr_reader :client

    def initialize
      @client = SavonClient.new
    end

    def get_inventory
      SoapMethods::GetInventory.new(
        savon_client: client
      ).result
    end

    def receiving_ticket_add(return_request_item:)
      SoapMethods::ReceivingTicketAdd.new(
        savon_client:        client,
        return_request_item: return_request_item
      ).result
    end

    def get_receiving_ticket_object_by_ticket_no
      # TODO
    end

    def style_master_product_add_by_spree_variants(spree_variants:)
      SoapMethods::StyleMasterProductAddBySpreeVariants.new(
        savon_client:   client,
        spree_variants: spree_variants
      ).result
    end

    def style_master_product_add_by_return_request_items(return_request_items:)
      SoapMethods::StyleMasterProductAddByReturnRequestItems.new(
        savon_client:         client,
        return_request_items: return_request_items
      ).result
    end

    def get_style_master_product_add_status_by_spree_variant(spree_variant:)
      SoapMethods::GetStyleMasterProductAddStatusBySpreeVariant.new(
        savon_client:  client,
        spree_variant: spree_variant
      ).result
    end

    def get_style_master_product_add_status_by_return_request_item(return_request_item:)
      SoapMethods::GetStyleMasterProductAddStatusByReturnRequestItem.new(
        savon_client:        client,
        return_request_item: return_request_item
      ).result
    end
  end
end
