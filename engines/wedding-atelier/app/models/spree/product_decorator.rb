Spree::Product.class_eval do

  def option_values_of(presentation)
    option_types.find_by_presentation(presentation).option_values
  end

end
