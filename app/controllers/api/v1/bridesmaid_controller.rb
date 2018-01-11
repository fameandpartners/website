module Api
  module V1
    class BridesmaidController < ApplicationController
      include Products::UploadHelper

      respond_to :json

      def show
        customized_product = CustomizationVisualization.find(params[:id])
        base_product = customized_product.product
        res = {}
        res[:product] = setup_product(base_product)
        res[:incompatible_ids] = customized_product.incompatible_ids.split(',')
        res[:image_urls] = JSON.parse(customized_product.render_urls).select {|x| x['color'] == params[:color]}
        res

        respond_with res

      end

      def index
        customized_products = CustomizationVisualization.where("length = ? AND silhouette = ? AND neckline in (?) AND render_urls @> ?",
                                                               params[:selectedLength], params[:selectedSilhouette], params[:selectedTopDetails], [{color:  params[:selectedColor]}].to_json)

        res = setup_collection(customized_products, params[:selectedColor])

        respond_with res
      end

      def incompatabilities
        customized_product = CustomizationVisualization.where("customization_ids = ? AND length = ? AND silhouette =? AND neckline = ?",
                                                               params[:customization_ids].sort, params[:length], params[:silhouette], params[:neckline]).first

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
                    price: product.site_price_for(site_version || SiteVersion.default) ,
                    currency: current_currency,
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
      def setup_product(prod)
        product = Products::DetailsResource.new(
          site_version: current_site_version,
          permalink:    prod.permalink
        ).read

        # only admins can view deleted products
        if product.is_deleted && !spree_current_user.try(:has_spree_role?, "admin")
        raise Errors::ProductInactive
        end

        # set preselected images colors
        color_hash = \
          if params[:color]
            Repositories::ProductColors.get_by_name(params[:color]) || {}
          else
            # select images of one/default color
            color = product.available_options.colors.default.first

            {
              id:   color&.id,
              name: color&.name
            }
          end

        product.color_id   = color_hash[:id]
        product.color_name = color_hash[:name]

        # todo: thanh 4/3/17- why would we want to default this following line
        # make express delivery as default option
        product.making_option_id = product.making_options.first.try(:id)

        product.use_auto_discount!(current_promotion.discount) if current_promotion

        if product.fit
          product.fit = product.fit.gsub(" Height", "Height")
          product.fit = product.fit.gsub("Height", ", Height")
          product.fit = product.fit.gsub(" Hips", "Hips")
          product.fit = product.fit.gsub("Hips", ", Hips")
          product.fit = product.fit.gsub(" Waist","Waist")
          product.fit = product.fit.gsub("Waist",", Waist")
        end
        return product
      end

    end
  end
end
