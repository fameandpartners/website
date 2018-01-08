module Api
  module V1
    class Bridesmaid < ApplicationController
      include Products::UploadHelper

      respond_to :json

      def show
        customized_product = CustomizationVisualization.find(params[:id])
      end

      def index
        customized_products = CustomizationVisualization.where("customization_ids = ? AND length = ? AND silhouette =? AND neck_line = ? AND render_urls @> ?", 
                                                               params[:customization_ids], params[:length], params[:silhouette], params[:neckline], [{color:  params[:color]}].to_json)

      end

    end 
  end
end