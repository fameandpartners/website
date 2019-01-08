module Forms
  class ManualOrderFilter

    HEIGHT_DISPLAY_NAMES = {
      'length1' => "Length1 (4'10\"-5'1\") or (148-156cm)",
      'length2' => "Length2 (5'2\"-5'4\") or (157-164cm)",
      'length3' => "Length3 (5'5\"-5'7\") or (165-172cm)",
      'length4' => "Length4 (5'8\"-5'10\") or (173-179cm)",
      'length5' => "Length5 (5'11\"-6'1\") or (180-186cm)",
      'length6' => "Length6 (6'2\"-6'4\") or (187-193cm)"
    }

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def size_options
      product_options[:sizes].map do |p|
        { id: p.id, name: p.name }
      end
    end

    def color_options
      product_options[:colors].map do |p|
        { id: p.id, name: p.presentation, type: 'color' }
      end
    end

    def fabric_options
      product_options[:fabrics].map do |p|
        { id: p.id, name: p.presentation, type: 'fabric' }
      end
    end

    def heights_options
      if product_heights_range_groups.first.blank? || product_heights_range_groups.first.name =~ /three_size/
        skirt_length_options[0..2]
      else
        skirt_length_options[3..-1]
      end
    end

    def skirt_length_options
      LineItemPersonalization::HEIGHTS.map { |h| { id: h, name: HEIGHT_DISPLAY_NAMES[h] || h.humanize } }
    end

    def customisations_options
      product_options[:customizations].map do |p|
        { id: p.id, name: "#{p.name} (+#{p.display_price})" }
      end
    end

    def images
      params.fetch(:product_colors, []).map do |_, param|
        p = Spree::Product.find(param.fetch(:product_id))
        fabric = Fabric.find(param.fetch(:fabric_id)) if param.fetch(:fabric_id).present?
        color = Spree::OptionValue.find(param.fetch(:color_id)) if param.fetch(:color_id).present?

        image = p.images_for_customisation(color&.name, fabric&.name, [], true)[0]

        { url: image&.attachment&.url(:large) }
      end
    end

    def price
      price = products\
        .map { |p| p.site_price_for(site_version).amount }
        .sum

      { price: price, currency: params[:currency] }
    end


    def users_searched
      first_name_term, last_name_term = params[:term].split(' ')
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

    def user_data
      user = Spree::User.find(params[:user_id])
      address = user.orders.complete.last.ship_address

      {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        address1: user.user_data.fetch(:address1, address.address1),
        address2: user.user_data.fetch(:address2, address.address2),
        city: user.user_data.fetch(:city, address.city),
        zipcode: user.user_data.fetch(:zipcode, address.zipcode),
        phone: user.user_data.fetch(:phone, address.phone),
        state_id: user.user_data.fetch(:state_id, address.state_id),
        country_id: user.user_data.fetch(:country_id, address.country_id)
      }
    end

    private

    def product_heights_range_groups
      ProductHeightRangeGroup.find_both_for_variant_or_use_default(product.master)
    end

    def site_version
      SiteVersion.where(currency: params[:currency]).first
    end

    def product
      Spree::Product.find(params[:product_id])
    end

    def products
      params.fetch(:product_ids, []).map do |id|
        Spree::Product.find(id)
      end
    end

    def product_options
      @product_options ||= Products::SelectionOptions.new(site_version: site_version, product: product).read
    end

    def extra_color_price
      product_options[:colors][:default_extra_price][:amount]
    end

  end
end
