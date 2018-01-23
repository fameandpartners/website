module Api
  module V1
    class BridesmaidController < ApplicationController

      respond_to :json

      def index
        if !validate_params([:selectedColor, :selectedTopDetails, :selectedLength, :selectedSilhouette], params)
          respond_with nil, status: :not_acceptable
        else
          customized_products = CustomizationVisualization.where("lower(length) = ? AND lower(silhouette) = ? AND lower(neckline) in (?) AND render_urls @> ? ",
                                                                 params[:selectedLength].downcase, params[:selectedSilhouette].downcase, params[:selectedTopDetails].map { |x| x.downcase }, [{color:  params[:selectedColor]}].to_json)
                                                          .order('Length(customization_ids)')  #gets base most customization 
          
          customized_products = customized_products.uniq_by{ |x| x.product_id.to_s + x.neckline } #only present one of each product and neckline combo

          res = setup_collection(customized_products, params[:selectedColor])
          respond_with res
        end
      end

      def incompatabilities
        if !validate_params([:customization_ids, :product_id, :length], params)
          respond_with nil, status: :not_acceptable
        else

          customized_products = CustomizationVisualization.where("customization_ids = ? AND product_id = ?",
                                                                 params[:customization_ids].sort.join('_'), params[:product_id])


          if params[:length].downcase == 'micro-mini'
            customized_product = customized_products.select{ |x| x.length.downcase ==  params[:length].downcase  ||  x.length.downcase == 'cheeky' }.first

          else
            customized_product = customized_products.select{ |x| x.length.downcase ==  params[:length].downcase }.first
          end

          if customized_product.nil?
            respond_with nil, status: :not_found

          else

            product_length_custs = JSON.parse(customized_product.product.customizations).select{ |x| x['customisation_value']['group'] == 'Lengths' }
            
            lengths = customized_products.map { |x| "change-to-#{x.length.downcase}" }
            
            compatible_lengths = product_length_custs.select{ |x| lengths.include?(x['customisation_value']['name']) }
            

            res = {}
            res[:id] = customized_product.id
            res[:compatible_lengths] = compatible_lengths.map{ |x| x['customisation_value']['id']}
            res[:incompatible_ids] = customized_product.incompatible_ids.split(',').reject { |x| res[:compatible_lengths].include?(x) }

            @swatch_colors = fabric_swatch_colors.to_json

            respond_with res

          end
        end

      end

      private

      def validate_params(required_params, passed_params)
        required_params.each do |rp|
          if !passed_params.has_key?(rp)
            return false #TODO: Make this cooler when we upgrade to rails 4
          end
        end
        return true
      end

      def setup_collection(customized_products, color)
        collection = []
        customized_products.each do |cp|
          product = cp.product
          collection << { 
                    id: cp.id,
                    product_name: "#{cp.length} Length #{cp.silhouette} Dress with #{cp.neckline} #{cp.neckline.include?('Neckline') ? '' : Neckline}", # product.name, #TODO: Need to do this per dorothy's suggestion
                    color_count: product.colors.count,
                    customization_count: JSON.parse(product.customizations).count,
                    price: product.master.price_in(current_currency.upcase).attributes,
                    image_urls: JSON.parse(cp.render_urls).select { |x| x['color'] == color }
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
