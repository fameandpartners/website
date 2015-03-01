# obsoleted. reason - it caches not wishlist, but wishlist items
=begin
module Repositories
class UserWishlist
  attr_reader :owner, :site_version

  def initialize(options = {})
    @owner        = options[:owner]
    @site_version = options[:site_version]
  end

  def read
    OpenStruct.new({
      owner_name: owner.full_name,
      owner_id: owner.id,
      items: wishlist_items.map{ |item| build_item(item) }
    })
  end

  def drop_cache
    #Rails.cache.delete(cache_key)
  end

  private

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
        product_color_ids: item.product.color_ids,
        master_id: item.product.master.id,
        variant_id: variant_id,
        variants: [item.spree_variant_id],
        color: color,
        #color_customizable: products_with_color_customisation.include?(item.spree_product_id),
        quantity: item.quantity,
        permalink: item.product.permalink,
        fast_delivery: item.product.fast_delivery,
        image_url: product_image(item.product, color),
        price: product_price(item.product)
      )
    end

    def product_color(item)
      if item.product_color_id.present?
        Repositories::ProductColors.read(item.product_color_id)
      elsif color = item.variant.dress_color
        Repositories::ProductColors.read(color.id)
      end
    end

    def product_image(product, color)
      options = {}
      if color.present?
        options[:color_id] = color.id
      end
      image = Repositories::ProductImages.new(product: product).read(options)
      image.large
    end

    def product_price(item)
      Repositories::ProductPrice.new(product: product, site_version: site_version).read
    end

    def products_with_color_customisation
      @products_with_color_customisation ||= begin
        candidates = wishlist_items.map(&:spree_product_id)
        property_id = Spree::Property.where(name: 'color_customization').first.try(:id)
        Spree::ProductProperty.where(
          property_id: property_id,
          product_id: candidates
        ).where('TRIM(LOWER(value)) IN (?)', %w{y yes}).pluck(:product_id)
      end
    end
end
end
=end
