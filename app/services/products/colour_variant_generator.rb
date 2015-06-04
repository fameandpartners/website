module Products
  class ColourVariantGenerator

    attr_reader :product

    def initialize(product: product)
      @product      = product
      @color_option = Spree::OptionType.color
      @size_option  = Spree::OptionType.size
    end

    def create_variants(size_ids, color_ids)
      sizes  = @size_option.option_values.where(id: size_ids)
      colours = @color_option.option_values.where(id: color_ids)

      master = product.master

      sizes.each do |size|
        colours.each do |color|
          unless product_have_size_and_color?(size, color)

            variant = product.variants.build(filtered_attributes)

            variant.default_price = clone_price(master.default_price)

            other_prices = (master.prices - Array(master.default_price))
            other_prices.each do |price|
              variant.prices << clone_price(price).tap do |new_price|
                new_price.variant = variant
              end
            end
            variant.save

            variant.option_values = [size, color]
          end
        end
      end
    end

    private
    def clone_price(price)
      Spree::Price.new(amount: price.amount, currency: price.currency)
    end

    def filtered_attributes
      @filtered_attributes ||= begin
        excluded_attributes = %w{id created_at deleted_at sku is_master count_on_hand}
        product.master.attributes.except(*excluded_attributes)
      end
    end

    # TODO - Remove
    def get_product_default_price(product)
      if product.price
        product.prices.first
      elsif product.master.default_price
        product.master.default_price
      else
        product.variants.map(&:price).compact.first
      end
    end

    def product_option_ids
      @product_options ||= Products::VariantsReceiver.new(product).available_options.collect { |o| o.slice(:size_id, :color_id) }
    end

    def product_have_size_and_color?(size, color)
      product_option_ids.include?(:size_id => size.id, :color_id => color.id)
    end
  end
end
