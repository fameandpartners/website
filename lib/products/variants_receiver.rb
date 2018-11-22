module Products
  class VariantsReceiver
    def initialize(product_or_id)
      product_or_id = product_or_id.first if product_or_id.is_a?(ActiveRecord::Relation)
      @product_id = product_or_id.respond_to?(:id) ? product_or_id.id : product_or_id
    end

    # returns [{ variant_id: 123, color: 'black', color_code: '#000000', image: '', size: 12, available: true} ]
    def available_options
      color_option  = Spree::OptionType.color
      size_option   = Spree::OptionType.size

      available_options = []
      Spree::Variant.active.where(is_master: false, product_id: @product_id).includes(:option_values).each do |variant|
        available_option = { id: variant.id }
        variant.option_values.each do |option_value|
          if option_value.option_type_id == color_option.id
            available_option[:color] = option_value.name
            available_option[:color_presentation] = option_value.presentation
            available_option[:color_id] = option_value.id
            available_option[:color_value]  = option_value.value
            available_option[:image] = option_value.image.url(:small_square) if option_value.image?
          elsif option_value.option_type_id == size_option.id
            available_option[:size] = Integer(option_value.name) rescue option_value.name
            available_option[:size_presentation] = option_value.presentation
            available_option[:size_id] = option_value.id
            available_option[:size_value] = Integer(option_value.name) rescue option_value.name
          end
        end

        # spree has more correct available? method,
        available_option[:available] = variant.available?

        available_options.push(available_option)
      end

      return available_options
    end
  end
end
