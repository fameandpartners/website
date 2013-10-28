module Spree
  module Admin
    class ProductColorsController < BaseController
      before_filter :load_product, :load_option_types

      def new
      end

      def create
        @variants = create_variants(params[:sizes], params[:colors])

        flash.notice  = 'Variants successfully added'
        redirect_to admin_product_variants_path(@product)
      end

      private

      def load_product
        @product = Spree::Product.find(params[:product_id])
      end

      def load_option_types
        @color_option = Spree::OptionType.where(name: 'dress-color').first
        @size_option  = Spree::OptionType.where(name: 'dress-size').first
      end

      def create_variants(sizes_ids, colors_ids)
        variants = []
        size_option_values = @size_option.option_values.where(id: sizes_ids)
        color_option_values = @color_option.option_values.where(id: colors_ids)

        master_variant = @product.master
        excluded_attributes = %w{id created_at deleted_at sku is_master count_on_hand}

        price = get_product_default_price(@product)

        size_option_values.each do |size_option_value|
          color_option_values.each do |color_option_value|
            unless product_have_size_and_color?(size_option_value, color_option_value)
              variant = @product.variants.build(master_variant.attributes.except(*excluded_attributes))
              # price.clone  have strrrange issues
              variant.default_price = Spree::Price.new(amount: price.amount, currency: price.currency)

              variant.save

              variant.option_values = [size_option_value, color_option_value]

              variants.push(variant)
            end
          end
        end

        return variants
      end

      def get_product_default_price(product)
        if product.price
          product.prices.first
        elsif product.master.default_price
          product.master.default_price
        else
          product.variants.map(&:price).compact.first
        end
      end

      def product_options
        @product_options ||= Products::VariantsReceiver.new(@product).available_options
      end

      def product_have_size_and_color?(size_option_value, color_option_value)
        size  = size_option_value.name
        color = color_option_value.name
        product_options.any?{|option| option[:size] == size && option[:color] == color }
      end
    end
  end
end
