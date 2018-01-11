module Api
  module V1
    class BridesmaidController < ApplicationController
      include Products::UploadHelper

      respond_to :json

      def index
        customized_products = CustomizationVisualization.where("length = ? AND silhouette = ? AND neckline in (?) AND render_urls @> ?",
                                                               params[:selectedLength], params[:selectedSilhouette], params[:selectedTopDetails], [{color:  params[:selectedColor]}].to_json)

        res = setup_collection(customized_products, params[:selectedColor])

        respond_with res
      end

      def incompatabilities
        customized_product = CustomizationVisualization.where("customization_ids = ? AND length = ? AND silhouette =? AND neckline = ? AND product_id = ?",
                                                               params[:customization_ids].sort.join(','), params[:length], params[:silhouette], params[:neckline], params[:product_id]).first

        customizations = JSON.parse(customized_product.product.customizations)
        incompatible_lengths =[]

        required_lengths = customizations.select {|x| !x['customisation_value']['required_by']['lengths'].empty?} #check to see if any of the lengths have a requirement

        if required_lengths
          required_customization_ids = required_lengths.map {|x| x['customisation_value']['id']}

          required_lengths.each do |required_length|
            unless params[:customization_ids].include?(required_length['customisation_value']['id'])
              incompatible_lengths = incompatible_lengths | required_length['customisation_value']['required_by']['lengths']
            end
          end

        end

        res = {}
        res[:incompatible_lengths] = incompatible_lengths
        res[:incompatible_ids] = customized_product.incompatible_ids.split(',')

        respond_with res

      end

      private

      def setup_collection(customized_products, color)
        collection = []
        customized_products.each do |cp|
          product = cp.product
          collection << { product_name: product.name,
                    color_count: product.colors.count,
                    customization_count: JSON.parse(product.customizations).count,
                    price: product.master.price_in(current_currency),
                    image_urls: JSON.parse(cp.render_urls).select {|x| x['color'] == color}
                  }
        end
        collection
      end

      def current_currency
        @current_currency ||= (site_version.try(:currency).to_s.downcase || 'usd')
      end

      def site_version
          @current_site_version ||= begin
            ::FindUsersSiteVersion.new(
                user:         current_spree_user,
                url_param:    request.env['site_version_code'],
                cookie_param: session[:site_version]
            ).get
          end
      end
    end
  end
end
