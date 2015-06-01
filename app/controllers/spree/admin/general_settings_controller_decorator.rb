Spree::Admin::GeneralSettingsController.class_eval do
  alias_method :original_edit, :edit
  def edit
    original_edit
    @preferences_general += [:homepage_title]
  end
end

