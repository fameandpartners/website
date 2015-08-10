module AdminUi
  class PreferencesController < AdminUi::ApplicationController
    def index
      @site_versions = ::SiteVersion.all
    end

    def update
      preferences_params.each do |name, value|
        next unless Spree::Config.has_preference? name
        Spree::Config[name] = value
      end

      redirect_to admin_ui.preferences_path, flash: { success: 'Preferences have been successfully updated!' }
    end

    private

    def preferences_params
      params[:preferences] || []
    end
  end
end
