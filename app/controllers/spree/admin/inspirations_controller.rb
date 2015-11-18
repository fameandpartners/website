module Spree
  module Admin
    class InspirationsController < BaseController
      include Spree::Admin::ImagesHelper

      def index
        render 'index', locals: { items: product.inspirations, product: product }
      end

      def new
        render 'new', locals: { product: product, item: product.inspirations.build }
      end

      def create
        item = product.inspirations.build(params[:inspiration])
        if item.save
          redirect_to admin_product_inspirations_path(product_id: product.permalink)
        else
          render 'index', locals: { items: product.inspirations, product: product, item: item }
        end
      end

      def edit
        item = product.inspirations.find(params[:id])
        render 'edit', locals: { product: product, item: item }
      end

      def update
        item = product.inspirations.find(params[:id])
        item.assign_attributes(params[:inspiration])

        respond_to do |format|
          format.html do
            item.save
            render 'index', locals: { items: product.inspirations, product: product, item: item }
          end
          format.js do
            if item.save
              render 'update', locals: { product: product, item: item }
            else
              render 'edit', locals: { product: product, item: item }
            end
          end
        end
      end

      def destroy
        item = product.inspirations.where(id: params[:id]).first
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
          Inspiration.update_all({ position: index }, {id: id})
        end
        render nothing: true
      end

      private

      def product
        @product ||= Spree::Product.find_by_permalink(params[:product_id])
      end

      def model_class
        Inspiration
      end
    end
  end
end
