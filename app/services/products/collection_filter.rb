# please, extract not user dependable data receiving to repo
class Products::CollectionFilter
  class << self
    def read
      OpenStruct.new({
        styles: Repositories::Taxonomy.read_styles,
        events: Repositories::Taxonomy.read_events,
        shapes: ProductStyleProfile::BODY_SHAPES,
        colors: Spree::Variant.color_option_type.try(:option_values) || [],
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
