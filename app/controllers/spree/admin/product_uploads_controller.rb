# TODO: this controller was the beginning of bulk importing products, which ended up being a shell script + rake task
module Spree
  module Admin
    class ProductUploadsController < BaseController
      def new
      end

      def show
      end

      def parse


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
