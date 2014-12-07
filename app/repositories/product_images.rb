module Repositories
class ProductImages
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read_all
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
      (images_from_variants + images_from_product_color_values).flatten.compact.sort_by {|image| image.position }
    end
  end
  alias_method :read, :read_all

  private

    def cache_key
      "product-images-#{ product.permalink }"
    end

    def cache_expiration_time
      return configatron.cache.expire.quickly if Rails.env.development?
      return configatron.cache.expire.quickly if Rails.env.staging?
      return configatron.cache.expire.long
    end

    def images_from_variants
      results = []
      product.variants_including_master.includes(:images, :option_values).each do |variant|
        variant.images.each do |image|
          result = OpenStruct.new(
            image_data(image).merge({
              color: variant.dress_color.try(:name),
              color_id: variant.dress_color.try(:id),
              size: variant.dress_size.try(:name),
              size_id: variant.dress_size.try(:id)
            })
          )
        end
      end
      results
    end

    def images_from_product_color_values
      results = []

      product.product_color_values.includes(:images, :option_value).each do |product_color_value|
        product_color_value.images.each do |image|
          result = OpenStruct.new(
            image_data(image).merge({
              color:    product_color_value.option_value.try(:name),
              color_id: product_color_value.option_value.try(:id),
              size:     nil,
              size_id:  nil
            })
          )
          results.push(result)
        end
      end
      results
    end

    # helper method
    def image_data(image)
      {
        id: image.id,
        position: image.position,
        original: image.attachment.url(:original),
        large: image.attachment.url(:large),
        xlarge: image.attachment.url(:xlarge),
        small: image.attachment.url(:small)
      }
    end
end
end
