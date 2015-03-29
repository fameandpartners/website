# usage
#   Repositories::ProductImages.new(product: product).read_all
#   Repositories::ProductImages.new(product: product).read
#   Repositories::ProductImages.new(product: product).filter(cropped: true/false)
#   Repositories::ProductImages.new(product: product).filter(color_id: color_id)
module Repositories
class ProductImages
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read_all
    @product_images ||= begin
      Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
        (images_from_variants + images_from_product_color_values).flatten.compact.sort_by {|image| image.position.to_i }
      end
    end
  end

  # filter read_all by
  #   color_id
  #   cropped
  def filter(options = {})
    scope = read_all
    if options[:color_id]
      scope = scope.select{|image| image.color_id == options[:color_id]}
    end
    if options.has_key?(:cropped)
      if options[:cropped]
        scope = scope.select{|image| image.large.to_s.downcase.include?('crop') }
      else # options[:cropped] => false
        scope = scope.select{|image| !image.large.to_s.downcase.include?('crop') }
      end
    end
    scope
  end

  # we can optimize it, if needed
  def read(options = {})
    filter(options).first || read_all.first || default_image
  end
  alias_method :default, :read

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

    def default_image(url = 'noimage/product.png')
      OpenStruct.new({
        id: nil,
        position: 0,
        original: url,
        large: url,
        xlarge: url,
        small: url
      })
    end
end
end
