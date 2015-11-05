require 'datagrid'

module AdminUi
  class VariantsController < AdminUi::ApplicationController

    class VariantsGrid
      include ::Datagrid

      scope do
        Spree::Variant
          .includes(:option_values, :option_values, :product)
          .where(product_id: Spree::Product.active)
      end

      column :sku
      column :generate_sku

    end


    def index
      @collection = VariantsGrid.new
      @collection.scope { |scope| scope.page(params[:page]).per(300) }
    end
  end
end
