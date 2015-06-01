Spree::Admin::GeneralSettingsController.class_eval do
  # TODO: 01/05/2015 alias_method gave production a stack level too deep
  # alias_method :original_edit, :edit
  # def edit
  #   original_edit
  #   @preferences_general += [:homepage_title]
  # end
end

