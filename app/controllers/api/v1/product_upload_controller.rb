module Api
  module V1
    class ProductUploadController < ApplicationController
      include Products::UploadHelper

      skip_before_filter :verify_authenticity_token
      respond_to :json

      def upload
        ActiveRecord::Base.transaction do
          product = create_or_update_products(request.body.read)
          respond_with product
        end
      end

    end 
  end
end
