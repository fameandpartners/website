module Repositories; end
class Repositories::UserMoodboardItem
  include Repositories::CachingSystem
  attr_reader :site_version, :item

  def initialize(options = {})
    @site_version = options[:site_version] || SiteVersion.default
    @item = options[:item]
  end

  def read
    OpenStruct.new(
      id: item.id,
      item_id: item.id,
      name: product.name,
      product_id: product.id,
      product_color_ids: product.color_ids,
      master_id: product.master.id,
      variant_id: item.spree_variant_id,
      variants: [item.spree_variant_id],
      color: color,
      quantity: item.quantity,
      permalink: product.permalink,
      fast_delivery: product.fast_delivery,
      image_url: product_image.large,
      price: product_price
    )
  end
  cache_results :read

  private

    def cache_key
      item.cache_key
    end

    def product
      item.product
    end

    def color
      return @color if instance_variable_defined?('@color')

      @color = begin
        if item.product_color_id.present?
          Repositories::ProductColors.read(item.product_color_id)
        elsif color = item.variant.dress_color
          Repositories::ProductColors.read(color.id)
        else
          nil
        end
      end
    end

    def product_image
      Repositories::ProductImages.new(product: product).read({ color_id: color.try(:id), cropped: true })
    end

    def product_price
      Repositories::ProductPrice.new(product: product, site_version: site_version).read
    end
end
