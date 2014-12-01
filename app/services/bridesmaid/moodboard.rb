class Bridesmaid::Moodboard
  attr_reader :site_version, :accessor, :moodboard_owner

  def initialize(options = {})
    @site_version     = options[:site_version]
    @accessor         = options[:accessor]
    @moodboard_owner  = options[:moodboard_owner]
  end

  def read
    OpenStruct.new({
      title:    title,
      owner:    moodboard_owner,
      products: moodboard_products
    })
  end

  private

    def title
      @title ||= "#{ moodboard_owner.full_name }'s mooodboard"
    end

    def currency
      site_version.currency.downcase
    end

    def bridesmaid_party_event
      @bridesmaid_party_event ||= BridesmaidParty::Event.where(spree_user_id: moodboard_owner.id).first_or_initialize
    end

    def wishlist_items
      @wishlist_items ||= moodboard_owner.wishlist_items.includes(:variant, :color, product: {master: :zone_prices})
    end

    def moodboard_products
      wishlist_items.map do |item|
        item_suitable?(item) ? build_item(item) : nil
      end.compact
    end

    def color_ids
      # it's not cached, and will generate second request in similar_products,
      # solve it with placing similar colors search to own repo
      @color_ids ||= begin
        color_ids = bridesmaid_party_event.colors.map{|c| c[:id]}
        similar_color_ids = Similarity.get_similar_color_ids(color_ids, Similarity::Range::VERY_CLOSE)
        color_ids + similar_color_ids
      end
    end

    def products_with_color_customisation
      @products_with_color_customisation ||= begin
        candidates = wishlist_items.map(&:spree_product_id)
        property_id = Spree::Property.where(name: 'color_customization').first.try(:id)
        Spree::ProductProperty.where(
          property_id: property_id,
          product_id: candidates,
          value: %w{y yes}
        ).pluck(:product_id)
      end
    end

    # we don't show red ( or similar ) dresses in moodboard, if user don't selected red color or unselected it
    # dresses, able to be customised also includes to list 
    def item_suitable?(item)
      color_id = if item.product_color_id.present?
        item.product_color_id
      else
        item.variant.dress_color.try(:id)
      end
      color_ids.include?(color_id) || products_with_color_customisation.include?(item.spree_product_id)
    end

    def build_item(item)
      OpenStruct.new(
        id: item.product.id,
        master_id: item.product.master.id,
        variant_id: item.spree_variant_id,
        variants: [item.spree_variant_id],
        name: item.product.name,
        permalink: item.product.permalink,
        fast_delivery: item.product.fast_delivery,
        image_url: product_image(item),
        price: product_price(item),
        path: product_path(item),
        'removable?' => can_manage?
      )
    end

    def can_manage?
      accessor == moodboard_owner
    end

    def product_image(item)
      #return 'noimage/product.png' if Rails.env.development?

      if item.product_color_id.present?
        product_color_value = item.product.product_color_values.where(option_value_id: item.product_color_id).first
        product_color_value.images.first.attachment.url(:large)
      else
        dress_color = item.variant.dress_color
        if dress_color.present?
          product_color_value = dress_color.product_color_values.where(product_id: item.product.id).first
          product_color_value.images.first.attachment.url(:large)
        else
          item.product.images.first.attachment.url(:large)
        end
      end
    #rescue 
    #  return 'noimage/product.png'
    end

    def product_price(item)
      item.product.master.zone_price_for(site_version)
    end

    #'/moodboard/:user_slug/dress-:product_slug(/:color_name)'
    def product_path(item)
      path_parts = [site_version.permalink, 'bridesmaid-party', bridesmaid_party_event.spree_user.slug]
      path_parts.push(
        ['dress', item.product.name.parameterize, item.product.id].reject(&:blank?).join('-')
      )
      color = item.color || item.variant.dress_color
      path_parts.push(color.name) if color.present?
      "/" + path_parts.join('/')
    end
end
