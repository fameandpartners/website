module Operations
  class ManualOrder

    attr_reader :params, :variant

    def initialize(params, variant)
      @params = params
      @variant = variant
    end

    def create
      order = Spree::Order.create
      site_version = SiteVersion.where(currency: params[:currency]).first

      cart = UserCart::Populator.new(
        order: order,
        site_version: site_version,
        currency: params[:currency],
        product: {
          variant_id: variant.id,
          size_id: params[:size],
          color_id: params[:color],
          customizations_ids: params[:customisations],
          height: params[:height],
          quantity: 1
        }
      ).populate

      order.customer_notes = params[:notes]
      order.currency = params[:currency]
      order.number = update_number(order.number) if params[:status] == 'exchange'

      if params[:existing_customer].present?
        user = Spree::User.find(params[:existing_customer])
        user_last_order = user.orders.complete.last
        order.bill_address_id = user_last_order.bill_address_id
        order.ship_address_id = user_last_order.ship_address_id
      else
        order.bill_address_id = Spree::Address.create(address_params).id
        order.ship_address_id = Spree::Address.create(address_params).id
      end

      order.save
      order
    end

    private

    def address_params
      {
        firstname: params[:first_name],
        lastname: params[:last_name],
        address1: params[:address1],
        address2: params[:address2],
        city: params[:city],
        state_id: params[:state],
        country_id: params[:country],
        zipcode: params[:zipcode],
        phone: params[:phone],
        email: params[:email]
      }
    end

    def update_number(_number)
      'E' + _number.gsub(/[^0-9]/, '')
    end

  end
end
