module Shippo
  class Label

    attr_reader :return_item_process

    def initialize(return_item_process)
      @return_item_process = return_item_process
    end

    def create

    end

    def transaction
      @transaction ||= Shippo::Transaction.create(
        rate: lowest_rate,
        label_file_type: 'PDF',
        async: false)
    end

    def shipment
      @shipment ||= Shippo::Shipment.create(
        object_purpose: 'PURCHASE',
        address_from: address_from,
        address_to: address_to,
        parcel: parcel,
        async: false)
    end

    def lowest_rate
      shipment.rates_list.min_by{|r| r[:amount].to_f}
    end

    def order
      @order ||= return_item_process.return_request_item.order_return_request.order
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
        email: ship_address.email
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
        length: 5,
        width: 2,
        height: 5,
        distance_unit: :in,
        weight: 2,
        mass_unit: :lb
      }
    end

  end
end
