class Repositories::ProductProperties
  attr_reader :product

  def initialize(options = {})
    @product = options[:product]
  end

  def read_all
    product_properties
  end

  def [](property_name)
    product_properties[property_name]
  end

  private

    def product_properties
      @all_properties ||= begin
        cache_key = "product-properties-#{ product.id }"
        Rails.cache.fetch(cache_key, Repositories::CachingSystem.cache_fetch_params({})) do
          properties = {}
          product.product_properties.includes(:property).each do |product_property|
            properties[product_property.property.name] = product_property.value
          end
          properties
        end
      end
    end
end
