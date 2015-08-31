Spree::AppConfiguration.class_eval do
  # Site wide preferences
  preference :free_customisations, :boolean, :default => false
  preference :homepage_title, :string, :default => ''

  # Site Version preferences
  SiteVersion.find_each do |site_version|
    # Titles
    titles = Preferences::Titles.new(site_version)
    preference titles.default_seo_title_key, :string, default: ''
    preference titles.homepage_title_key, :string, default: ''

    # Locale Warn
    warning = Preferences::LocaleWarn.new(site_version)
    preference warning.long_text_key, :string, default: ''

    # Top Banner
    top_banner = Preferences::TopBanner.new(site_version)
    preference top_banner.right_text_key, :string, default: ''
    preference top_banner.center_text_key, :string, default: ''
  end if SiteVersion.table_exists?
end
