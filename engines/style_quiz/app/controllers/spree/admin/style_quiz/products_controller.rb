module Spree::Admin::StyleQuiz
  class ProductsController < Spree::Admin::StyleQuiz::BaseController
    def index
      @search = model_class.ransack(params[:q])
      @products = @search.result(distinct: true).limit(10)
    end

    def edit
      @product = Spree::Product.find_by_permalink(params[:id])
    end

    def update
      @product = Spree::Product.find_by_permalink(params[:id])
      @product.tags = (params[:product][:tags] || []).map(&:to_i)
      @product.save

      redirect_to edit_admin_style_quiz_product_path(@product)
    end

    def destroy
      @product = Spree::Product.find_by_permalink(params[:id])
      @product.tags = []
      @product.save
    end

    private

      def model_class
        ::Spree::Product
      end
  end
end
