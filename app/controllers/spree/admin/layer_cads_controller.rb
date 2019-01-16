module Spree
  module Admin
    class LayerCadsController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink

      def index
        respond_with(collection)
      end

      private

      def model_class
        LayerCad
      end

      def collection
        parent.layer_cads
      end
    end
  end
end
