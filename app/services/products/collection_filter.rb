class Products::CollectionFilter

  Collection = Struct.new(:styles, :events, :shapes, :colors, :sort_orders) do
    def cache_key
      members.flat_map {|x| send(x).map {|i| i.respond_to?(:id) ? [i.id, i.try(:name)] : i } }.join(',')
    end
  end

  class << self
    def read
      Collection.new(
        Repositories::Taxonomy.read_styles,
        Repositories::Taxonomy.read_events,
        ProductStyleProfile::BODY_SHAPES.sort,
        Repositories::ProductColors.read_all,
        available_sort_orders
      )
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
