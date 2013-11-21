module Spree
  module Admin
    class SiteVersionsController < BaseController
      respond_to :html, :json

      def index
        @site_versions  = SiteVersion.all
      end

      def edit
        @site_version = SiteVersion.find(params[:id])
        @rate = Products::CurrencyConverter.get_rate(Spree::Config.currency, @site_version.currency)

        respond_with(@site_version) do |format|
          format.js { render 'spree/admin/site_versions/edit' }
        end
      end

      def update
        @site_version = SiteVersion.find(params[:id])
        new_rate = params[:site_version][:exchange_rate].to_f
        @site_version.update_exchange_rate(new_rate, force: true)

        respond_with(@site_version) do |format|
          format.js { render 'spree/admin/site_versions/update' }
        end
      end

      private

      def model_class
        SiteVersion
      end
    end
  end
end
