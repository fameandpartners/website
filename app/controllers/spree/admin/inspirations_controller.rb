module Spree
  module Admin
    class InspirationsController < BaseController
      before_filter :load_data

      def update
        if @celebrity_inspiration.update_attributes(params[:celebrity_inspiration])
          redirect_to edit_admin_product_inspiration_path(@product)
        else
          render :edit
        end
      end

      private

      def load_data
        @product = Product.find_by_permalink!(params[:product_id])
        @celebrity_inspiration = @product.celebrity_inspiration || @product.build_celebrity_inspiration
      end

      def model_class
        Spree::CelebrityInspiration
      end
    end
  end
end
