module Marketing
  class AddressPresenter
    extend Forwardable

    attr_reader :address

    def_delegators :address,
                   :address1,
                   :address2,
                   :alternative_phone,
                   :city,
                   :company,
                   :email,
                   :firstname,
                   :lastname,
                   :phone,
                   :state_name,
                   :zipcode

    def initialize(spree_address)
      @address = spree_address
    end

    def state
      address.state.to_s
    end

    def country
      address.country.to_s
    end

    def to_h
      {
        address1:          address1,
        address2:          address2,
        alternative_phone: alternative_phone,
        city:              city,
        company:           company,
        country:           country,
        email:             email,
        firstname:         firstname,
        lastname:          lastname,
        phone:             phone,
        state:             state,
        zipcode:           zipcode,
      }
    end
  end
end
