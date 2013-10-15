module Products
  class VariantsReceiver
    def initialize(product_or_id)
      product_or_id = product_or_id.first if product_or_id.is_a?(ActiveRecord::Relation)
      @product_id = product_or_id.respond_to?(:id) ? product_or_id.id : product_or_id
    end

    # returns [{ variant_id: 123, color: 'black', size: 12, fast_delivery: true} ]
    def available_options
      color_option  = Spree::OptionType.where(name: 'dress-color').first
      size_option   = Spree::OptionType.where(name: 'dress-size').first

      available_options = []
      Spree::Variant.active.where(is_master: false, product_id: @product_id).includes(:option_values).each do |variant|
        available_option = { id: variant.id }
        variant.option_values.each do |option_value|
          if option_value.option_type_id == color_option.id
            available_option[:color] = option_value.name
            available_option[:image] = option_value.image.url(:small_square) if option_value.image?
          elsif option_value.option_type_id == size_option.id
            available_option[:size] = option_value.name
          end
        end

        # if item in stock
        available_option[:fast_delivery] = variant.count_on_hand > 0

        available_options.push(available_option)
      end

      return available_options
    end
  end
end
