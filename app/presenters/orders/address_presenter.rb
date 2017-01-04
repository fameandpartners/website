require 'forwardable'

module Orders
  class AddressPresenter

    extend Forwardable

    attr_reader :spree_address

    def_delegators :spree_address,
                   :firstname,
                   :lastname,
                   :state,
                   :state_name,
                   :address1,
                   :address2,
                   :city,
                   :zipcode,
                   :phone,
                   :email

    def initialize(address)
      @spree_address = address
    end

    def full_name
      [firstname, lastname].compact.join(' ')
    end

    def address_lines
      [address1, address2].compact.join(' ')
    end

    def state_code
      state.try(:name) || state_name
    end

    def city_with_state
      [city, state_code].compact.join(', ')
    end
  end
end
