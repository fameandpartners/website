module Repositories
class ProductStyles
  attr_reader :currency, :product

  def initialize(options = {})
    @currency = options[:currency]
    @product = product_with_associations(options[:product])
  end

  def read
    grouped_styles_data.collect do |style, accessories|
      accessories ||= []
      FastOpenStruct.new({
        name: style.try(:name),
        title: style.try(:title),
        images: accessories.map{|item| item.image.present? ? item.image.url(:product) : nil }.compact,
        accessories: accessories.map do |item|
          FastOpenStruct.new(
            name: item.name,
            title: item.title,
            source: item.source,
            display_price: item.display_price(currency)
          )
        end
      })
    end
  end

  private

    def product_with_associations(product_candidate)
      Spree::Product.includes(accessories: :style).find(product_candidate.id)
    end

    def product_accessories
      @product_accessories ||= @product.accessories.order('style_id asc, position asc')
    end

    # group by not works - we need ordered hash
    def grouped_styles_data
      style_accessories = ActiveSupport::OrderedHash.new
      styles = {}
      product.accessories.order('style_id asc, position asc').each do |accessory|
        styles[accessory.style_id] ||= accessory.style
        style_accessories[accessory.style_id] ||= []
        style_accessories[accessory.style_id].push(accessory)
      end

      style_accessories.keys.collect do |style_id|
        [styles[style_id],  style_accessories[style_id]]
      end
    end
end
end
