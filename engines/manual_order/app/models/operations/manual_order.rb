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

      return false if cart[:success] == false

      if params[:existing_customer].present?
        user = Spree::User.find(params[:existing_customer])
        user_last_order = user.orders.complete.last
        order.user = user
        order.bill_address = user_last_order.bill_address
        order.ship_address = user_last_order.ship_address
      else
        order.user = Spree::User.create_user(user_params)
        order.bill_address = Spree::Address.create(address_params)
        order.ship_address = Spree::Address.create(address_params)
      end

      order.user_first_name = params[:first_name] || order.bill_address.firstname
      order.user_last_name = params[:last_name] || order.bill_address.lastname
      order.email = params[:email] || order.bill_address.email
      order.currency = params[:currency]
      order.customer_notes = params[:notes]
      order.site_version = site_version.permalink
      order.number = update_number(order.number) if params[:status] == 'exchange'

      order.save
      order
    end

    private

    def user_params
      {
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email]
      }
    end

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
