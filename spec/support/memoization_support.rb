module MemoizationSupport
  def rememoize(klass, instance_variable_symbol)
    klass.instance_variable_set(instance_variable_symbol, nil)
  end

  module_function :rememoize
end

RSpec.configure do |config|
  config.before(:each) do
    MemoizationSupport.rememoize(SiteVersion, :@default)
    MemoizationSupport.rememoize(SiteVersion, :@permalinks)
    MemoizationSupport.rememoize(Spree::OptionType, :@color)
    MemoizationSupport.rememoize(Spree::OptionType, :@size)
    MemoizationSupport.rememoize(Repositories::ProductColors, :@color_groups)
    MemoizationSupport.rememoize(ProductSize, :@sizes_map)
    MemoizationSupport.rememoize(Spree::Variant, :@size_option_type)
    MemoizationSupport.rememoize(Spree::OptionType, :@size)
  end
end
