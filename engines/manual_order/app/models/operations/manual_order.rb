module Operations
  class ManualOrder

    attr_reader :params, :order

    def initialize(params)
      @params = params
    end

    def create
      Rails.logger.info(params.inspect)
      if populate_products.all? { |cart| cart[:success] }
        if params[:existing_customer].present?
          assign_customer
        else
          create_customer
        end

        fill_order_details
        order.save!
        finalize_order
        create_inventory_units
        adjust_price
        create_global_skus

        order
      else
        false
      end
    end

    private

    def populate_products
      params[:products].map do |_, product|
        color = product[:color]
        
        if !product[:fabric].blank?
          fabric = Fabric.find(product[:fabric])
          color = fabric.option_value_id
          variant = get_variant(product[:style_name], product[:size], fabric.option_fabric_color_value_id) 
        else
          variant = get_variant(product[:style_name], product[:size], color) 
        end

        UserCart::Populator.new(
          order: order,
          site_version: site_version,
          currency: params[:currency],
          product: {
            variant_id: variant.id,
            size_id: product[:size],
            color_id: color,
            fabric_id: product[:fabric],
            customizations_ids: product[:customisations],
            height: product[:height],
            quantity: 1
          }
        ).populate
      end
    end


    def assign_customer
      user = Spree::User.find(params[:existing_customer])

      new_address_params = address_params.merge(
        firstname: user.first_name,
        lastname:  user.last_name,
        email:     user.email
      )

      order.user = user
      order.bill_address = Spree::Address.create(new_address_params)
      order.ship_address = Spree::Address.create(new_address_params)

      user.update_attribute(:user_data, new_address_params)
    end

    def create_customer
      order.user = Spree::User.create_user(user_params)
      order.bill_address = Spree::Address.create(address_params)
      order.ship_address = Spree::Address.create(address_params)
    end

    def fill_order_details
      order.user_first_name = params[:first_name] || order.bill_address.firstname
      order.user_last_name = params[:last_name] || order.bill_address.lastname
      order.email = params[:email] || order.bill_address.email
      order.currency = params[:currency]
      order.customer_notes = params[:notes]
      order.site_version = site_version.permalink
      order.number = update_number(order.number)
    end

    def finalize_order
      order.touch :completed_at
      order.update_column :state, 'complete'
    end

    def create_inventory_units
      params[:products].each do |_, product|
        color = product[:color]
        
        if !product[:fabric].blank?
          fabric = Fabric.find(product[:fabric])
          color = fabric.option_value_id
        end
        variant = get_variant(product[:style_name], product[:size], color) 

        unit = order.shipments.first.inventory_units.build
        unit.variant_id = variant.id
        unit.order_id = order.id
        unit.save
      end
    end

    def adjust_price
      if params[:adj_amount].present? && params[:adj_description].present?
        order.adjustments.create({ amount: params[:adj_amount], label: "Manual #{params[:adj_description]}" })
      end
    end

    def create_global_skus
      order.line_items.each do |line_item|
        line_item_presenter = Orders::LineItemPresenter.new(line_item, order)
        GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
      end
    end

    def order
      @order ||= Spree::Order.create
    end

    def site_version
      SiteVersion.where(currency: params[:currency]).first
    end

    def user_params
      {
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email]
      }
    end

    def address_params
      addr = {
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

      addr.merge!({state_name: 'no state'}) unless params[:state].present?
      addr
    end

    def update_number(_number)
      (params[:status] == 'exchange' ? 'E' : 'M') + _number.gsub(/[^0-9]/, '')
    end

    def get_variant(product_id, size, color)
      size_variants  = get_variant_ids(product_id, size)
      color_variants = get_variant_ids(product_id, color)

      variant_ids = \
        if size_variants.present? && color_variants.present?
          size_variants & color_variants
        elsif color_variants.present?
          color_variants
        else
          size_variants
        end

      Spree::Variant.where(id: variant_ids).first!
    end

    def get_variant_ids(product_id, option_value_id)
      Spree::Variant
        .joins(:option_values)
        .joins(:prices)
        .where('spree_option_values.id = ?', option_value_id)
        .where(product_id: product_id, is_master: false)
        .where('spree_prices.currency = ? AND spree_prices.amount IS NOT NULL', params[:currency] || 'USD')
        .pluck(:id)
    end

  end
end
