module Spree
  module Admin
    class ProductImagesController < BaseController
      include Spree::Admin::ImagesHelper

      respond_to :json
      before_filter :load_product

      def upload
        if params[:product] && params[:product][:images]
          viewable = Curation.find!(params[:product][:viewable_id])

          images = params[:product][:images].collect do |attachment|
            image = Spree::Image.new(attachment: attachment)
            image.viewable = viewable
            image.save!
            image
          end

          render json: {files: images.map{|t| serialize_image(t)}}, status: :created
        else
          raise 'error'
        end
      end

      private

      def load_product
        @product = Spree::Product.find(params[:product_id])
      end

      def serialize_image(image)
        {
          "name" => image.read_attribute(:photo_file_name),
          "size" => image.read_attribute(:photo_file_size),
          "spree_dom_id" => "spree_image_#{image.id}",
          "thumbnail_url" => image.attachment.url(:mini),
          "image_url" => image.attachment.url(:product),
          "edit_url" => edit_admin_product_image_url(@product, image),
          "delete_url" => admin_product_image_url(@product, image),
          "delete_type" => "DELETE",
          "variant" => options_text_for(image)
        }
      end
    end
  end
end
