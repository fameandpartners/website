module Spree
  module Admin
    class ProductUploadsController < BaseController
      def new
      end

      def show
      end

      def parse
        uploader = Products::BatchUploader.new()
        uploader.parse_file(params[:file], params[:start])

        @parsed_data = uploader.parsed_data

        render action: :show
      end

      def create
        products_data = []
        params[:products].each do |index, args|
          if args[:upload].to_s == '1'
            products_data.push(args)
          end
        end
        @products = Products::BatchUploader.new.create_or_update_products(products_data)

        render action: :show
      end
    end
  end
end
