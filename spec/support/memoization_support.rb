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
    MemoizationSupport.rememoize(Spree::OptionType, :@color)
    MemoizationSupport.rememoize(Spree::OptionType, :@size)

    # Legacy
    MemoizationSupport.rememoize(Repositories::ProductColors, :@color_groups)
    MemoizationSupport.rememoize(Repositories::ProductSize, :@sizes_map)
    ProductColorValue.belongs_to(:option_value, class_name: 'Spree::OptionValue',
                                 conditions: ['option_type_id = ?', Spree::OptionType.color_scope ])
  end
end
