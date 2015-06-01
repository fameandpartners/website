module Spree
  module Admin
    class ProductMakingOptionsController < BaseController
      before_filter :load_product

      def index
        @making_options = @product.making_options
      end

      def new
        @making_option = @product.making_options.new 
        @making_option.assign_default_attributes
      end

      def create
        @making_option = @product.making_options.new(params[:product_making_option])
        if @making_option.save
          flash[:success] = 'Product option successfully created'
          redirect_to action: :index
        else
          render action: :new
        end
      end

      def destroy
        @product.making_options.where(id: params[:id]).destroy_all
      end

        private

        def model_class
          ::ProductMakingOption
        end

        def load_product
          @product ||= Product.find_by_permalink(params[:product_id])
        end
    end
  end
end
