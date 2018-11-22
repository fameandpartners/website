module Spree
  module Admin
    class ProductMakingOptionsController < BaseController
      def index
        load_product

        @making_options = @product.making_options
      end

      def new
        load_product

        @making_option = @product.making_options.new
      end

      def create
        load_product

        @making_option = @product.making_options.new(params[:product_making_option])
        if @making_option.save
          redirect_to action: :index, flash: { success: 'Product option successfully created' }
        else
          render action: :new
        end
      end

      def edit
        load_product
        load_product_making_option
      end

      def update
        load_product
        load_product_making_option

        if @product_making_option.update_attributes(params[:product_making_option])
          flash[:success] = 'Product Making Option was successfully updated'
          redirect_to action: :index
        else
          render :edit
        end
      end

      def toggle
        load_product_making_option

        @product_making_option.update_attribute(:active, !@product_making_option.active)

        redirect_to action: :index
      end

      private

      def model_class
        ::ProductMakingOption
      end

      def load_product
        @product = Spree::Product.find_by_permalink(params[:product_id])
      end

      def load_product_making_option
        @product_making_option = model_class.find(params[:id])
      end
    end
  end
end
