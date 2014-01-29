module Spree
  module Admin
    class MoodboardItemsController < BaseController
      include Spree::Admin::ImagesHelper
      respond_to :json

      def index
        render 'index', locals: { items: product.moodboard_items, product: product }
      end

      def new
        render 'new', locals: { product: product, item: product.moodboard_items.build }
      end

      def create
        item = product.moodboard_items.build(params[:moodboard_item])
        if item.save
          redirect_to admin_product_moodboard_items_path(product_id: product.permalink)
        else
          render 'index', locals: { items: product.moodboard_items, product: product, item: item }
        end
      end

      def destroy
        item = product.moodboard_items.where(id: params[:id]).first
        if item
          item.destroy
        else
          item = nil
        end

        render 'destroy', locals: { item: item }
      end

      # i know, this should be moven to separate controller.
      def update_positions
        params[:positions].each do |id, index|
          MoodboardItem.update_all({ position: index }, {id: id})
        end
        render nothing: true
      end

      private

      def product
        @product ||= Spree::Product.find_by_permalink(params[:product_id])
      end

      def model_class
        MoodboardItem
      end
    end
  end
end
