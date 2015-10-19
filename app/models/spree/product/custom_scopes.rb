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
    end
  end
end
