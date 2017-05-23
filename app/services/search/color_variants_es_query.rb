module Search
  class ColorVariantsESQuery
    require 'elasticsearch/dsl'
    include Elasticsearch::DSL

    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentation
      colors            = options[:color_ids]
      body_shapes       = options[:body_shapes]
      taxon_ids         = options[:taxon_ids]
      exclude_products  = options[:exclude_products]
      discount          = options[:discount]
      query_string      = options[:query_string]
      order             = options[:order]
      fast_making       = options[:fast_making]
      limit             = options[:limit].present? ? options[:limit].to_i : 1000
      offset            = options[:offset].present? ? options[:offset].to_i : 0
      price_min         = Array.wrap(options[:price_min]).map(&:to_f)
      price_max         = Array.wrap(options[:price_max]).map(&:to_f)
      currency          = options[:currency]
      show_outerwear    = !!options[:show_outerwear]
      exclude_taxon_ids = options[:exclude_taxon_ids] if query_string.blank?

      product_orderings = self.product_orderings(currency: currency)

      product_ordering = product_orderings.fetch(order) do
        if query_string.present?
          # Do not apply ordering for searches, let ES order by term relevance.
          product_orderings['native']
        else
          product_orderings['newest']
        end
      end
      binding.pry
      hash = Elasticsearch::DSL::Search.search do
        query do
          filtered do
            bool do
              must do
                term 'product.is_deleted' => false
                term 'product.is_hidden' => false
                # Outerwear filter
                term 'product.is_outerwear' => show_outerwear
                # Only available items
                term 'product.in_stock' => true

                if fast_making.present?
                  term 'product.fast_making' => fast_making
                end

                if taxon_ids.present?
                  term 'product.taxon_ids' => taxon_ids
                end

              end
              should do
                range 'product.available_on' => { :lte => Time.now}
              end
            end
            if colors.present?
              term 'color.id' => colors
            end
          end
          filter do
            exists field: 'available_on'
          end
        end
      end



      hash
    end

    def self.product_orderings(currency: nil)
      ProductOrdering.new(currency: currency).all
    end

    class ProductOrdering
      attr_accessor :all, :currency

      def initialize(currency: nil)
        self.currency = currency
        self.all = {}
        add_orders
      end

      def add(name, description, behaviour)
        all.update(name => {
          description: description,
          behaviour: behaviour
        })
      end

      def all_as_collection
        all.map { |key, value| [value[:description], key]  }
      end

      private

      def add_orders
        price_behaviour_field = currency.present? ? "prices.#{currency}" : 'product.price'

        add('price_high',     "Price: High to Low",            [price_behaviour_field, 'desc'])
        add('price_low',      "Price: Low to High",            [price_behaviour_field, 'asc'])
        add('newest',         "Newest First",                  ['product.created_at', 'desc'])
        add('oldest',         "Oldest First",                  ['product.created_at', 'asc'])
        add('fast_delivery',  "Show Fast Delivery First",      ['product.fast_delivery', 'desc'])
        add('best_sellers',   "Best Sellers",                  ['product.total_sales', 'desc'])
        add('alpha_asc',      "Name: A-Z",                     ['product.name', 'asc'])
        add('alpha_desc',     "Name: Z-A",                     ['product.name', 'desc'])
        add('native',         "Do Not Apply Ordering",         nil)
      end
    end
  end
end
