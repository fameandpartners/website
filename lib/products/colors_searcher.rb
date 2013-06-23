module Products
  class ColorsSearcher
    def initialize(products)
      @products = products.is_a?(Array) ? products : [products]
    end

    def retrieve_colors
      colors = Hash.new() {|this, key| this[key] = Array.new() }

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

=begin
  # return 
  # { product_id: list_of_colors }
  def available_colors_for(dresses)
    products = [products] unless products.is_a?(Array)
    color_option_type = Spree::OptionType.where(name: 'product-color').first

    {}.tap do |colors|
      products.each do |product|
        colors[product.id] = product.variants.includes(:option_values).collect do |variant|
          variant.option_values.select{|option| option.option_type_id == color_option_type.id }
        end.flatten.uniq
      end
    end
  end
=end
