module Spree
  module Admin
    class ProductAccessoriesController < BaseController
      before_filter :load_product

      def index
        @accessories = @product.accessories.includes(:style).order('style_id asc, position asc')
      end

      def new
        @accessory = @product.accessories.new 
      end

      def create
        @accessory = @product.accessories.new(params[:product_accessory])
        if @accessory.save
          flash[:success] = 'Product accessory successfully created'
          redirect_to action: :index
        else
          render action: :new
        end
      end

      def edit
        @accessory = @product.accessories.find(params[:id])
      end

      def update
        @accessory = @product.accessories.find(params[:id])
        if @accessory.update_attributes(params[:product_accessory])
          flash[:success] = 'Product Accessory successfully update'
          redirect_to action: :index
        else
          render action: :edit
        end
      end

      def update_positions
        params[:positions].each do |id, index|
          ProductAccessory.update_all({ position: index }, {id: id})
        end
        render nothing: true
      end

      def destroy
        @accessory = @product.accessories.find(params[:id])
        if @accessory
          @accessory.try(:destroy)
        end
      end

      private

      def model_class
        ::ProductAccessory
      end

      def load_product
        @product ||= Product.find_by_permalink(params[:product_id])
      end
    end
  end
end
