module Search
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

        def self.product_orderings(currency: nil)
            ProductOrdering.new(currency: currency).all
        end

        private

        def add_orders
            price_behaviour_field = \
                if currency.present?
                "prices.#{currency}"
                else
                'product.price'
                end

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