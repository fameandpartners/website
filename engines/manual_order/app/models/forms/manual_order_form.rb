require 'reform'

module Forms
  class ManualOrderForm < ::Reform::Form

    property :currency, virtual: true
    property :style_name, virtual: true
    property :size, virtual: true
    property :length, virtual: true
    property :color, virtual: true
    property :customisations, virtual: true
    property :notes, virtual: true
    property :status, virtual: true
    property :email, virtual: true
    property :first_name, virtual: true
    property :last_name, virtual: true
    property :address1, virtual: true
    property :address2, virtual: true
    property :city, virtual: true
    property :state, virtual: true
    property :country, virtual: true
    property :zipcode, virtual: true
    property :phone, virtual: true
    property :existing_customer, virtual: true

    def products
      Spree::Product.active
    end

    def countries
      order_cond = "iso!='US', iso!='CA', iso!='DE', iso!='MX', iso!='GB', iso!='AU', iso!='NZ', name"
      @countries ||= Spree::Country.select([:id, :name]).order(order_cond).map {|c| [c.id, c.name]}
    end

    def states
      @states ||= Spree::Country.where(iso: 'US').first.states
    end

    def states_us
      @states_us ||= states.map {|s| {id: s.id, name: s.name}}
    end

    def states_ca
      @states_ca ||= Spree::Country.where(iso: 'CA').first.states.map {|s| {id: s.id, name: s.name}}
    end

    def states_au
      @states_au ||= Spree::Country.where(iso: 'AU').first.states.map {|s| {id: s.id, name: s.name}}
    end

    def customers
      user_ids = Spree::Order.complete.select('DISTINCT user_id').limit(10).pluck(:user_id)
      @customers ||= Spree::User.where(id: user_ids).limit(10).map {|u| [u.id, u.full_name]}
    end

    def get_size_options(product_id)
      products.find(product_id).variants.map {|v| { id: v.dress_size.id, name: v.dress_size.name} }.uniq
    end

    def get_color_options(product_id)
      products.find(product_id).variants
        .map {|v| { id: v.dress_color.id, name: v.dress_color.presentation, type: 'color'} }.uniq
    end

    def get_custom_colors(product_id)
      custom_colors = products.find(product_id).product_color_values.where(custom: true).pluck(:option_value_id)
      Spree::OptionValue.colors.where('id IN (?)', custom_colors)
        .map {|c| { id: c.id, name: "#{c.presentation} (+ $16.00)", type: 'custom' } }.uniq
    end

    def get_customisations_options(product_id)
      products.find(product_id).customisation_values
        .map {|c| { id: c.id, name: "#{c.presentation} (+ $#{c.price})" } }
    end

    def get_image(product_id, size_id, color_id)
      variant = get_variant(product_id, size_id, color_id)
      url = if variant.present? && variant_image(variant).try(:attachment).present?
              variant_image(variant).attachment.url(:large)
            else
              'null'
            end
      { url: url }
    end

    def get_price(product_id, size_id, color_id, currency = 'USD')
      price = get_variant(product_id, size_id, color_id).get_price_in(currency)
      { price: price.amount, currency: currency }
    end

    def get_users_searched(term)
      first_name_term, last_name_term = term.split(' ')
      operator = 'AND'
      if last_name_term.nil?
        last_name_term = first_name_term
        operator = 'OR'
      end

      user_ids = Spree::Order.complete.select('DISTINCT user_id').pluck(:user_id)
      Spree::User.where(id: user_ids)
        .where("first_name ILIKE ? #{operator} last_name ILIKE ?", "%#{first_name_term}%", "%#{last_name_term}%")
        .limit(10).map {|u| {id: u.id, value: u.full_name}}
    end

    def get_user_data(user_id)
      user = Spree::User.find(user_id)
      address = user.orders.complete.last.ship_address

      {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        address1: address.address1,
        address2: address.address2,
        city: address.city,
        zipcode: address.zipcode,
        phone: address.phone,
        state_id: address.state_id,
        country_id: address.country_id
      }
    end

    def site_version_options
      {
        'USD' =>'USA',
        'AUD' => 'Australia'
      }
    end

    def skirt_length_options
      {
        'petite' =>'Petite',
        'standard' => 'Standard',
        'tall' => 'Tall'
      }
    end

    def save_order(params)
      variant = get_variant(params[:style_name], params[:size], params[:color])
      Operations::ManualOrder.new(params, variant).create
    end

    private

    def get_variant(product_id, size_id, color_id)
      size_variants = if size_id.to_i > 0
                        Spree::OptionValue.find(size_id).variants
                          .where(product_id: product_id, is_master: false).pluck(:id)
                      else
                        nil
                      end
      color_variants = Spree::OptionValue.find(color_id).variants
                         .where(product_id: product_id, is_master: false).pluck(:id)
      variant_ids = if size_variants.present? && color_variants.present?
                      size_variants & color_variants
                    elsif color_variants.present?
                      color_variants
                    else
                      size_variants
                    end
      Spree::Variant.where(id: variant_ids).first
    end

    def variant_image(variant)
      cropped_images_for(variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
    end

  end
end
