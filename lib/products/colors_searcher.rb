module Products
  class ColorsSearcher
    def initialize(products)
      @products = products.is_a?(Array) ? products : [products]
    end

    def retrieve_colors
      colors = Hash.new() {|this, key| this[key] = Array.new() }
      return colors if color_option_type.blank?

      products_with_options = Spree::Product.where(id: @products.map(&:id)).includes(variants: :option_values)

      products_with_options.each do |product|
        colors[product.id] = product.variants.includes(:option_values).collect do |variant|
          variant.option_values.select{|option| option.option_type_id == color_option_type.id }
        end.flatten.uniq
      end

      colors
    end

    private

    def color_option_type
      @color_option_type ||= Spree::OptionType.where(name: 'dress-color').first
    end
  end
end
