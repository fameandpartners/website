module Products
  class ColourVariantGenerator

    attr_reader :product

    def initialize(product: product)
      @product      = product
      @color_option = Spree::OptionType.color
      @size_option  = Spree::OptionType.size
    end

    def create_variants(sizes_ids, colors_ids)
      size_option_values  = @size_option.option_values.where(id: sizes_ids)
      color_option_values = @color_option.option_values.where(id: colors_ids)

      master = product.master

      size_option_values.each do |size_option_value|
        color_option_values.each do |color_option_value|
          unless product_have_size_and_color?(size_option_value, color_option_value)

            variant = product.variants.build(filtered_attributes)

            variant.default_price = Spree::Price.new(
              amount:   master.default_price.amount,
              currency: master.default_price.currency
            )
            other_prices          = master.prices - Array(master.default_price)
            other_prices.each do |price|
              variant.prices << Spree::Price.new(amount: price.amount, currency: price.currency).tap do |new_price|
                new_price.variant = variant
              end
            end
            variant.save

            variant.option_values = [size_option_value, color_option_value]
          end
        end
      end
    end

    private

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
