module Search
  class ColorVariantsESQuery
    require 'elasticsearch/dsl'
    include Elasticsearch::DSL

    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentation
      colors            = options[:color_ids] #
      body_shapes       = options[:body_shapes] #
      taxon_ids         = options[:taxon_ids] #
      exclude_products  = options[:exclude_products]  #no!
      discount          = options[:discount]  #
      query_string      = options[:query_string]
      order             = options[:order]
      fast_making       = options[:fast_making]
      limit             = options[:limit].present? ? options[:limit].to_i : 1000
      offset            = options[:offset].present? ? options[:offset].to_i : 0
      price_mins         = Array.wrap(options[:price_min]).map(&:to_f)
      price_maxs         = Array.wrap(options[:price_max]).map(&:to_f)
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
                # We need to filter products by exact ids of taxon records
                # Ref: https://www.elastic.co/guide/en/elasticsearch/guide/current/_finding_multiple_exact_values.html#_equals_exactly
                if taxon_ids.present?
                  taxon_terms = taxon_ids.map do |tid|
                    { term: { 'product.taxon_ids' => tid } }
                  end
                end
              end

              # exclude products found
              if exclude_products.present?
                must_not do
                  term id: exclude_products
                end
              end

              # exclude items marked not-a-dress
              if exclude_taxon_ids.present?
                must_not do
                  term 'product.taxon_ids' => exclude_taxon_ids
                end
              end

              should do
                range 'product.available_on' => { :lte => Time.now}
              end

              if body_shapes.present?
                body_shapes.each do |bs|
                  should do
                    range "product.#{bs}" => {:gte => 4}
                  end
                end
              end

              if discount.present?
                if discount == :all?
                  should do
                    term range 'product.discount' => { :gt => 0 }
                  end
                else
                  must do
                    term 'product.discount' => discount.to_i
                  end
                end
              end

              if price_min.present? || price_max.present?
                ColorVariantsESQuery.build_pricing_comparison(price_mins, price_maxs, currency)
              end
            end

            filter do
              if colors.present?
                term 'color.id' => colors
              end

              exists field: 'available_on'


            end
          end

          query do
            if query_string.present?
              query_string do
                query "product.name:(#{query_string})^4 OR color.name:(#{query_string})^2 OR product.sku:(#{query_string})^2 OR product.taxon_names:(#{query_string})^2 OR product.description:(#{query_string})"
              end
            end
          end
        end
      end

binding.pry

      hash
    end

    def self.build_pricing_comparison(min_prices, max_prices, currency)
      Filter.new do
        min.prices.zip(max_prices).map do |min, max|
          should { Range.new "sale_prices.#{currency}" => {gte: min, lte: max} }
        end
      end
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
