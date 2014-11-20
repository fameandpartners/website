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

    def wishlist_items
      @wishlist_items ||= moodboard_owner.wishlist_items.includes(:variant, product: {master: :zone_prices})
    end

    def moodboard_products
      wishlist_items.map do |item|
        build_item(item)
      end
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
      #return 'noimage/product.png'

      dress_color = item.variant.dress_color
      if dress_color.present?
        product_color_value = dress_color.product_color_values.where(product_id: item.product.id).first
        product_color_value.images.first.attachment.url(:large)
      else
        item.product.images.first.attachment.url(:large)
      end
    #rescue 
    #  return 'noimage/product.png'
    end

    def product_price(item)
      item.product.master.zone_price_for(site_version)
    end

    def product_path(item)
      path_parts = [site_version.permalink, 'dresses']
      path_parts.push(
        ['dress', item.product.name.parameterize, item.product.id].reject(&:blank?).join('-')
      )
      if color = item.variant.dress_color
        path_parts.push(color.name)
      end
      "/" + path_parts.join('/')
    end
end
