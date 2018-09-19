class Products::CollectionFilter

  Collection = Struct.new(:styles, :events, :shapes, :colors, :sort_orders) do
    def cache_key
      members.flat_map {|x| send(x).map {|i| i.respond_to?(:id) ? [i.id, i.try(:name)] : i } }.join(',')
    end
  end

  class << self
    def read
      Collection.new(
        Repositories::Taxonomy.collect_filterable_taxons,
        Repositories::Taxonomy.read_events,
        ProductStyleProfile::BODY_SHAPES.sort,
        Repositories::ProductColors.read_all,
        Search::ProductOrdering.product_orderings
      )
    end
  end
end
