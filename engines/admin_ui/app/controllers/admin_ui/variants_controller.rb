require 'datagrid'

module AdminUi
  class VariantsController < AdminUi::ApplicationController

    class VariantsGrid
      include ::Datagrid

      scope do
        Spree::Variant
          .active
          .includes(:option_values, :option_values, :product)
          .where(product_id: Spree::Product.active)
      end


      column :name
      column :dress_color do |x|
        x.dress_color.try(:name)
      end
      column :dress_size do |x|
        x.dress_size.try(:name)
      end

      column :sku, label: 'Old Sku'
      column :generate_sku, label: 'New SKU'

    end


    def index
      @collection = VariantsGrid.new
      @collection.scope { |scope| scope.page(params[:page]).per(300) }
    end
  end
end
