module Products
  class ColorsSearcher
    def initialize(products)
      if products.is_a?(ActiveRecord::Relation)
        @products = products.to_a
      elsif !products.is_a?(Array)
        @products = [products]
      else
        @products = products
      end
    end

    def retrieve_colors
      colors = Hash.new() {|this, key| this[key] = Array.new() }
      return colors if color_option_type.blank?

      products_with_options = Spree::Product.where(id: @products.map(&:id)).includes(variants: :option_values)

      products_with_options.each do |product|
        colors[product.id] = product.variants.collect do |variant|
          variant.option_values.select{|option| option.option_type_id == color_option_type.id }
        end.flatten.uniq
      end

      colors
    end

    private

    def color_option_type
      @color_option_type ||= Spree::OptionType.color
    end
  end
end
