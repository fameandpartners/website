module Api
  module V1
    class BridesmaidController < ApplicationController

      respond_to :json

      def index
        customized_products = CustomizationVisualization.where("lower(length) = ? AND lower(silhouette) = ? AND lower(neckline) in (?) AND lower(render_urls)c @> ? ",
                                                               params[:selectedLength].downcase, params[:selectedSilhouette].downcase, params[:selectedTopDetails].downcase, [{color:  params[:selectedColor].downcase}].to_json)
                                                        .order('Length(customization_ids)')  #gets base most customization 
        
        customized_products = customized_products.uniq_by{ |x| x.product_id.to_s + x.neckline } #only present one of each product and neckline combo

        res = setup_collection(customized_products, params[:selectedColor])
        respond_with res
      end

      def incompatabilities
        customized_product = CustomizationVisualization.where("customization_ids = ? AND lower(length) = ? AND product_id = ?",
                                                               params[:customization_ids].sort.join('_'), params[:length].downcase, params[:product_id].downcase).first

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
          collection << { 
                    id: cp.id,
                    product_name: product.name,
                    color_count: product.colors.count,
                    customization_count: JSON.parse(product.customizations).count,
                    price: product.master.price_in(current_currency.upcase).attributes,
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
