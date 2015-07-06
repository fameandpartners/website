module Spree::Admin::StyleQuiz
  class ProductsController < Spree::Admin::StyleQuiz::BaseController
    def index
      @products = model_class.where("tags is not null")
    end

    private

      def model_class
        ::Spree::Product
      end
  end
end
