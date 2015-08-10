module AdminUi
  class PreferencesController < AdminUi::ApplicationController
    def index
      @site_versions = ::SiteVersion.all
    end

    def update
      begin
        preferences_params.each { |name, value| Spree::Config[name] = value }
        flash[:success] = 'Preferences have been successfully updated!'
      rescue NoMethodError
        flash[:error] = 'Preferences were not updated.'
      end

      redirect_to admin_ui.preferences_path
    end

    private

    def preferences_params
      params[:preferences] || []
    end
  end
end
