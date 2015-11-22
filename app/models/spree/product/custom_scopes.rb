module Spree
  class Product
    module CustomScopes
      def hydrated_from_ids(ids)
        unscoped.hydrated.where(id: Array(ids))
      end

      def hydrated
        includes(:variants             => [:prices],
                 :master               => [:prices],
                 :product_color_values => {:images => []})
      end

      def with_making_options
        joins(:making_options)
      end

      def with_fast_making
        with_making_options.where("product_making_options.option_type = 'fast_making'")
      end
    end
  end
end
