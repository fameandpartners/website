module Api
  module V1
    class ProductUploadController < ApplicationController
      include Products::UploadHelper

      respond_to :json

      def upload
      	product = create_or_update_products(request.body.string)
        respond_with product.to_json
      end


    end


  end
end
