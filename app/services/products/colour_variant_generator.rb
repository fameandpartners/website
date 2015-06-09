module Products
  class ColourVariantGenerator

    attr_reader :product

    def initialize(product: product)
      @product      = product
      @color_option = Spree::OptionType.color
      @size_option  = Spree::OptionType.size
    end

    def create_variants(size_ids, color_ids)
      sizes   = @size_option.option_values.where(id: size_ids)
      colours = @color_option.option_values.where(id: color_ids)

      sizes.each do |size|
        colours.each do |color|
          create_variant size, color
        end
      end
    end

    def create_variant(size, color)
      return if existing_size_and_color?(size, color)

      variant = product.variants.build(master_attributes)

      variant.default_price = clone_price(master.default_price, into: variant)

      other_prices.each do |price|
        variant.prices << clone_price(price, into: variant)
      end

      variant.option_values = [size, color]
      variant.save
    end

    private

    def existing_size_and_color?(size, color)
      existing_option_ids.include?(:size_id => size.id, :color_id => color.id)
    end

    def master_attributes
      @master_attributes ||= begin
        excluded_attributes = %w{id created_at deleted_at sku is_master count_on_hand}
        product.master.attributes.except(*excluded_attributes)
      end
    end

    def master
      product.master
    end

    def clone_price(source, into:)
      Spree::Price.new(
        amount:   source.amount,
        currency: source.currency
      ).tap do |new_price|
        # Spree doesn't do this for us, yet throws validation errors without it.
        new_price.variant = into
      end
    end

    def other_prices
      @other_prices ||= (master.prices - Array(master.default_price))
    end

    def existing_option_ids
      @existing_option_ids ||= Products::VariantsReceiver
                                 .new(product)
                                 .available_options
                                 .collect { |o| o.slice(:size_id, :color_id) }
    end
  end
end
