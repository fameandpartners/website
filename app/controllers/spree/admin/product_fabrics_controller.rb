module Spree
  module Admin
    class ProductFabricsController < BaseController
      before_filter :load_product

      def new
        @fabric_product = @product.fabric_products.new(params[:fabrics_product])
      end

      def index
        @fabric_products = @product.fabric_products
      end

      def create
        @fabric_product = @product.fabric_products.new(params[:fabrics_product])
        if @fabric_product.save
          redirect_to action: :index, flash: { success: 'Fabric successfully created' }
        else
          render action: :new
        end
      end

      def edit
        load_fabric_product
      end

      def update
        load_fabric_product

        if @fabric_product.update_attributes(params[:fabrics_product])
          flash[:success] = 'Fabric Option was successfully updated'
          redirect_to action: :index
        else
          render :edit
        end
      end

      private

      def load_fabric_product
        @fabric_product = @product.fabric_products.find(params[:id])
      end

      def load_product
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end
    end
  end
end
