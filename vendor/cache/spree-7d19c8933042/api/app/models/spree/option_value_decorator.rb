Spree::OptionValue.class_eval do
  def option_type_name
    option_type.name
  end
end
