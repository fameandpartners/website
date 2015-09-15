module Spree
  module Admin
    module GeneralSettingsControllerExtensions
      def edit
        super
        @preferences_general -= [:default_seo_title, :default_meta_keywords]
      end
    end
  end
end

Spree::Admin::GeneralSettingsController.class_eval do
  prepend Spree::Admin::GeneralSettingsControllerExtensions
end
