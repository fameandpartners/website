module Spree
  module Admin
    class CurationsController < ResourceController
      belongs_to 'spree/product', :find_by => :permalink

      def index
        respond_with(collection)
      end

      private

      def model_class
        Curation
      end

      def collection
        parent.curations.includes(:taxons)
      end
    end
  end
end
