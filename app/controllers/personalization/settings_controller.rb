module Personalization
  class SettingsController < BaseController
    def edit
      @settings = find_or_build_settings
    end

    def update
      @settings = find_or_build_settings

      if @settings.update_attributes(params[:personalization_settings])
        redirect_to personalization_products_path
      else
        render :edit
      end
    end

    private

    def find_or_build_settings
      current_spree_user.personalization_settings ||
        current_spree_user.build_personalization_settings
    end
  end
end
