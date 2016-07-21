module Shippo
  class Label

    attr_reader :return_request_item

    def initialize(return_request_item)
      @return_request_item = return_request_item
    end

    def create
      transaction_results
    end

  private

    def transaction_results
      {
        status: transaction.object_status,
        label_url: transaction.label_url,
        tracking_number: transaction.tracking_number,
        messages: transaction.messages
      }
    end

    def transaction
      @transaction ||= Shippo::Transaction.create(
        rate: lowest_rate[:object_id],
        label_file_type: 'PDF',
        async: false)
    end

    def lowest_rate
      shipment.rates().min_by{|r| r[:amount].to_f}
    end

    def shipment
      @shipment ||= Shippo::Shipment.create(
        object_purpose: 'PURCHASE',
        address_from: address_from,
        address_to: address_to,
        parcel: parcel,
        async: false)
    end

    def order
      @order ||= return_request_item.order_return_request.order
    end

    def ship_address
      @ship_address ||= order.ship_address
    end

    def address_from
      {
        object_purpose: 'PURCHASE',
        name: ship_address.full_name,
        street1: ship_address.address1,
        street2: ship_address.address2,
        city: ship_address.city,
        state: ship_address.state.abbr,
        zip: ship_address.zipcode,
        country: ship_address.country.iso,
        phone: ship_address.phone,
        email: ship_address.email || order.email
      }
    end

    def address_to
      {
        object_purpose: 'PURCHASE',
        name: 'Fame & Partners Inc',
        company: 'C/O Bergen Logistics West',
        street1: '15905 Commerce Way ',
        city: 'Cerritos',
        state: 'CA',
        zip: '90703',
        country: 'US',
        phone: '+1 555 341 9393',
        email: 'support@fameandpartners.com'
      }
    end

    def parcel
      {
        length: 14,
        width: 8,
        height: 2,
        distance_unit: :in,
        weight: 2.5,
        mass_unit: :lb
      }
    end

  end
end
