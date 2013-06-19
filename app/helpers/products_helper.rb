module ProductsHelper
  # create decorator?
  # move to model?
  # use custom searcher ?
  def available_product_colors(product)
    color_option_type = Spree::OptionType.where(name: 'dress-color').first

    product.variants.includes(:option_values).collect do |variant|
      variant.option_values.select{|option| option.option_type_id == color_option_type.id }
    end.flatten.uniq
  end
end
