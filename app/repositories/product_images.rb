# usage
#   Repositories::ProductImages.new(product: product).read_all
#   Repositories::ProductImages.new(product: product).read
#   Repositories::ProductImages.new(product: product).filter(cropped: true/false)
#   Repositories::ProductImages.new(product: product).filter(color_id: color_id)
module Repositories
class ProductImages
  PRODUCT_COLOR_VALUE     = 'ProductColorValue'
  SPREE_VARIANT           = 'Spree::Variant'

  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read_all(options = {})
    @product_images ||= begin
      Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
        if product.fabrics.empty?
          images_from_product_color_values.flatten.compact.sort_by {|image| image.position.to_i }
        else
          images_from_product_fabric_values.flatten.compact.sort_by {|image| image.position.to_i }
        end
      end
    end

    if options.has_key?(:cropped)
      if options[:cropped]
        @product_images = @product_images.select{|image| image.large.to_s.downcase.include?('crop') }
      else # options[:cropped] => false
        @product_images = @product_images.select{|image| !image.large.to_s.downcase.include?('crop') }
      end
    end

    @product_images
  end

  def get_product_images(products)
    # load images for all products and split them by products
    table_name = Spree::Image.quoted_table_name

    variants_including_master_ids_by_product = products.inject({}) do |result, product|
      result[product.id] = product.variants.select {|v| v.deleted_at.nil?}.map(&:id)
      result
    end

    variants_including_master_ids = variants_including_master_ids_by_product.values.flatten.uniq

    product_images = Spree::Image.includes(:viewable).where(
      "(#{table_name}.viewable_type = '#{PRODUCT_COLOR_VALUE}' AND #{table_name}.viewable_id IN (?))
        OR
      (#{table_name}.viewable_type = '#{SPREE_VARIANT}' AND #{table_name}.viewable_id IN (?))",
      products.map(&:product_color_value_ids).flatten.uniq, variants_including_master_ids
    ).inject({}) do |result, image|
      if image.viewable_type == PRODUCT_COLOR_VALUE
        products.select {|product| product.product_color_value_ids.include?(image.viewable_id)}.each do |product|
          result[product.id] ||= []
          result[product.id] << image
        end
      elsif image.viewable_type == SPREE_VARIANT
        products.select {|product| variants_including_master_ids_by_product[product.id].include?(image.viewable_id)}.each do |product|
          result[product.id] ||= []
          result[product.id] << image
        end
      end
      result
    end

    product_images.each do |product_id, images|
      images.sort_by!(&:position)
    end

    product_images
  end

  # filter read_all by
  #   color_id
  #   cropped
  def filter(options = {})
    scope = read_all(options)
    if options[:color_id]
      scope = scope.select{|image| image.color_id == options[:color_id]}
    end
    scope
  end

  # TODO: this should return a Repositories::Images::Template
  # we can optimize it, if needed
  # @return [OpenStruct]
  def read(options = {})
    filter(options).first || read_all(options).first || default_image
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

    def images_from_product_fabric_values
      results = []

      product.fabric_products.includes(:images, :fabric).each do |product_fabric_value|
        product_fabric_value.images.each do |image|
          result = OpenStruct.new(
            image_data(image).merge({
              fabric:    product_fabric_value.fabric.try(:name),
              fabric_id: product_fabric_value.fabric.try(:id),
              size:     nil,
              size_id:  nil
            })
          )
          results.push(result)
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
        product: image.attachment.url(:product),
        large: image.attachment.url(:large),
        xlarge: image.attachment.url(:xlarge),
        small: image.attachment.url(:small)
      }
    end

    # TODO: should be a `Repositories::Images::Template`
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
