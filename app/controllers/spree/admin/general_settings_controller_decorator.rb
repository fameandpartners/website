module Spree
  module Admin
    module GeneralSettingsControllerExtensions
      def edit
        super
        @preferences_general += [:homepage_title]
      end
    end
  end
end

Spree::Admin::GeneralSettingsController.class_eval do
  prepend Spree::Admin::GeneralSettingsControllerExtensions
end
