module Spree
  module Admin
    class ProductVideosController < BaseController
      before_filter :load_product

      def index
        @videos = @product.videos.order('position asc')
      end

      def new
        @colors = @product.basic_colors
        @video = @product.videos.new 
      end

      def create
        @video = @product.videos.new(params[:product_video])
        if @video.save
          flash[:success] = 'Product video successfully created'
          redirect_to action: :index
        else
          render action: :new
        end
      end

      def edit
        @colors = @product.basic_colors
        @video = @product.videos.find(params[:id])
      end

      def update
        @video = @product.videos.find(params[:id])
        if @video.update_attributes(params[:product_video])
          flash[:success] = 'Product video has been successfully updated.'
          redirect_to action: :index
        else
          render action: :edit
        end
      end

      def destroy
        @video = @product.videos.where(id: params[:id]).first
        @video.try(:destroy)
      end

      def update_positions
        params[:positions].each do |id, position|
          ProductVideo.update_all({ position: position }, {id: id})
        end
        render nothing: true
      end

      private

      def model_class
        ::ProductVideo
      end

      def load_product
        @product ||= Product.where(permalink: params[:product_id]).includes(:properties).first
      end
    end
  end
end
