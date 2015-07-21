
Spree::AppConfiguration.class_eval do
  # General preferences
  preference :free_customisations, :boolean, :default => false
  preference :homepage_title, :string, :default => ''

  # Top Banner Preferences
  SiteVersion.find_each do |site_version|
    preference "#{site_version.code}_top_banner_center_text", :string, default: ''
    preference "#{site_version.code}_top_banner_right_text", :string, default: ''
  end
end
