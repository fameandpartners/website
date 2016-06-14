Spree::Admin::GeneralSettingsController.class_eval do

  layout 'spree/layouts/admin'

  def edit
    @preferences_general = [:site_name,
                            :default_meta_description, :site_url]
    @preferences_security = [:allow_ssl_in_production,
                             :allow_ssl_in_staging, :allow_ssl_in_development_and_test,
                             :check_for_spree_alerts]
    @preferences_currency = [:display_currency, :hide_cents]
  end
end
