module Spree
  module Admin
    class LocalePreferencesController < BaseController
      def index
        @site_versions = SiteVersion.all
      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end

        redirect_to admin_locale_preferences_path, flash: { success: t(:successfully_updated, resource: 'Locale Preferences') }
      end
    end
  end
end

