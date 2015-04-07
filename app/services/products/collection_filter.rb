# don't think what caching require here
# possible, it should be done layer up or down from here
class Products::CollectionFilter
  class << self
    def read
      FastOpenStruct.new({
        styles: Repositories::Taxonomy.read_styles,
        events: Repositories::Taxonomy.read_events,
        shapes: ProductStyleProfile::BODY_SHAPES,
        colors: Repositories::ProductColors.read_all,
        sort_orders: available_sort_orders
      })
    end

    # copy-paste from Spree::Variant.color_option_type.try(:option_values) 
    # Products::ProductsFilter.available_sort_orders,
    def available_sort_orders
      [
        ['price_high', 'Price High'],
        ['price_low', 'Price Low'],
        ['newest', "What's new"],
        ['fast_delivery', 'Next day delivery']
      ]
    end
  end
end
