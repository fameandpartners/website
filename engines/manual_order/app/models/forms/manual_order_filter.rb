module Forms
  class ManualOrderFilter

    attr_reader :params

    def initialize(params)
      @params = params
    end

    def size_options
      product_options[:sizes][:default].map do |p|
        { id: p.id, name: p.name }
      end
    end

    def color_options
      product_options[:colors][:default].map do |p|
        { id: p.id, name: p.presentation, type: 'color' }
      end
    end

    def custom_colors
      product_options[:colors][:extra].map do |p|
        { id: p.id, name: "#{p.presentation} (+ $#{extra_color_price})", type: 'custom' }
      end
    end

    def customisations_options
      product_options[:customizations][:all].map do |p|
        price = p[:display_price].money.dollars
        { id: p.id, name: "#{p.name} (+ $#{price})" }
      end
    end

    def image
      variant = get_variant
      url = if variant.present? && variant_image(variant).try(:attachment).present?
              variant_image(variant).attachment.url(:large)
            else
              'null'
            end
      { url: url }
    end

    def price
      price = get_variant.get_price_in(params[:currency])
      { price: price.amount, currency: params[:currency] }
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
        address1: address.address1,
        address2: address.address2,
        city: address.city,
        zipcode: address.zipcode,
        phone: address.phone,
        state_id: address.state_id,
        country_id: address.country_id
      }
    end

    private

    def site_version
      SiteVersion.where(currency: params[:currency]).first
    end

    def product
      Spree::Product.find(params[:product_id])
    end

    def product_options
      @product_options ||= Products::SelectionOptions.new(site_version: site_version, product: product).read
    end

    def get_variant
      size_variants = params[:size_id].to_i > 0 ? get_variant_ids(params[:size_id]) : nil
      color_variants = get_variant_ids(params[:color_id])
      variant_ids = if size_variants.present? && color_variants.present?
                      size_variants & color_variants
                    elsif color_variants.present?
                      color_variants
                    else
                      size_variants
                    end
      Spree::Variant.where(id: variant_ids).first
    end

    def extra_color_price
      product_options[:colors][:default_extra_price][:amount]
    end

    def get_variant_ids(option_value_id)
      Spree::OptionValue.find(option_value_id).variants
        .where(product_id: params[:product_id], is_master: false)
        .joins(:prices)
        .where("spree_prices.currency = '#{params[:currency] || 'USD'}' and spree_prices.amount IS NOT NULL")
        .pluck(:id)
    end

    def variant_image(variant)
      cropped_images_for(variant.product.images_for_variant(variant))
    end

    def cropped_images_for(image_set)
      image_set.select { |i| i.attachment.url(:large).downcase.include?('front-crop') }.first
    end

  end
end
