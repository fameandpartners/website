module Repositories
class UserWishlist
  attr_reader :owner, :site_version

  def initialize(options = {})
    @owner        = options[:owner]
    @site_version = options[:site_version]
  end

  def read
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
      OpenStruct.new({
        owner_name: owner.full_name,
        owner_id: owner.id,
        items: wishlist_items.map{ |item| build_item(item) }
      })
    end
  end

  private

    def cache_key
      "user-wishlist-#{ owner.id }"
    end

    def cache_expiration_time
      return configatron.cache.expire.quickly if Rails.env.development?
      return configatron.cache.expire.quickly if Rails.env.staging?
      return configatron.cache.expire.long
    end

    def currency
      site_version.currency.downcase
    end

    def wishlist_items
      @wishlist_items ||= owner.wishlist_items.includes(:variant, :color, product: {master: :zone_prices})
    end

    def build_item(item)
      variant_id  = item.spree_variant_id
      color = product_color(item)

      OpenStruct.new(
        id: item.id,
        item_id: item.id,
        name: item.product.name,
        product_id: item.product.id,
        master_id: item.product.master.id,
        variant_id: variant_id,
        variants: [item.spree_variant_id],
        color: color,
        color_customizable: products_with_color_customisation.include?(item.spree_product_id),
        quantity: item.quantity,
        permalink: item.product.permalink,
        fast_delivery: item.product.fast_delivery,
        image_url: product_image(item.product, color),
        price: product_price(item)
      )
    end

    def product_color(item)
      if item.product_color_id.present?
        color = Spree::OptionValue.find(item.product_color_id)
        return OpenStruct.new(id: color.id, name: color.name, presentation: color.presentation)
      end

      color = item.variant.dress_color
      if color.present?
        return OpenStruct.new(id: color.id, name: color.name, presentation: color.presentation)
      end

      nil
    end

    def product_image(product, color)
      product_images = Repositories::ProductImages.new(product: product).read_all
      product_images.find{|image| image.color_id == color.id }.try(:large) || product_images.first.try(:large)
    end

    def product_price(item)
      item.product.master.zone_price_for(site_version)
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
end
end
