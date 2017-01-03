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
                   :zipcode

    def initialize(address)
      @spree_address = address
    end
  end
end
