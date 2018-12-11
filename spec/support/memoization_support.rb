module MemoizationSupport
  def rememoize(klass, instance_variable_symbol)
    klass.instance_variable_set(instance_variable_symbol, nil)
  end

  module_function :rememoize
end

RSpec.configure do |config|
  config.before(:each) do
    # Ours
    MemoizationSupport.rememoize(SiteVersion, :@default)
    MemoizationSupport.rememoize(SiteVersion, :@permalinks)

    # Spree
    MemoizationSupport.rememoize(Spree::Variant, :@size_option_type)
    MemoizationSupport.rememoize(Spree::Variant, :@color_option_type)
    MemoizationSupport.rememoize(Spree::OptionType, :@color)
    MemoizationSupport.rememoize(Spree::OptionType, :@size)

    # Legacy
    MemoizationSupport.rememoize(Repositories::ProductColors, :@color_groups)
    MemoizationSupport.rememoize(Repositories::ProductColors, :@colors_map)

    # TODO: this is redeclaring the `ProductColorValue.belongs_to`, since Rails `conditions` options are cached by class!
    # TODO: this option was removed on Rails 4, and should not be there! That should be a simple validation, or something like that!
    # TODO: check file: /app/models/product_color_value.rb
    ProductColorValue.belongs_to(:option_value, class_name: 'Spree::OptionValue',
                                 conditions:                ['option_type_id = ?', Spree::OptionType.color_scope])
  end
end
