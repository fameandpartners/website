module Spree
  module Admin
    class ProductStyleProfileController < BaseController
      before_filter :load_data

      def update
        if @style_profile.update_attributes(params[:product_style_profile])
          redirect_to edit_admin_product_style_profile_url(@product)
        else
          render :edit
        end
      end

      private

      def load_data
        @product = Product.find_by_permalink!(params[:product_id])
        @style_profile = ::ProductStyleProfile.find_by_product_id(@product.id)
      end

      def model_class
        ::ProductStyleProfile
      end
    end
  end
end
