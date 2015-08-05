module AdminUi
  class PreferencesController < AdminUi::ApplicationController
    def index
      @site_versions = SiteVersion.all
    end

    def update
      params.each do |name, value|
        next unless Spree::Config.has_preference? name
        Spree::Config[name] = value
      end

      redirect_to admin_ui.preferences_path, flash: { success: t(:successfully_updated, resource: 'Preferences') }
    end
  end
end
