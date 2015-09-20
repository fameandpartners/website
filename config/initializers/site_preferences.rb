Spree::AppConfiguration.class_eval do
  # Site wide preferences
  preference :free_customisations, :boolean, :default => false
  preference :homepage_title, :string, :default => ''

  # Site Version preferences
  SiteVersion.find_each do |site_version|
    # Titles
    titles = Preferences::Titles.new(site_version)
    preference titles.homepage_title_key, :string, default: ''

    # Locale Warn
    warning = Preferences::LocaleWarn.new(site_version)
    preference warning.long_text_key, :string, default: ''

    # Top Banner
    top_banner = Preferences::TopBanner.new(site_version)
    preference top_banner.right_text_key, :string, default: ''
    preference top_banner.center_text_key, :string, default: ''

    # SEO
    seo_preferences = Preferences::SEO.new(site_version)
    preference seo_preferences.default_seo_title_key, :string, default: ''
    preference seo_preferences.default_meta_description_key, :string, default: 'Shop for killer formal dresses you can make your own; customise colour, hem and dress fabrics for any type of special occasion.'

    #Shopping Bag
    shopping_bag = Preferences::ShoppingBag.new(site_version)
    preference shopping_bag.value_proposition_key, :string, default: "<i class='coathanger'></i><span>Free Styling Session</span><i class='plane'></i><span>Free delivery in US, CANADA & UK </span><i class='mobile'></i><span>24/7 Customer Service</span>"

  end if SiteVersion.table_exists?

  begin
    Spree::Config[:us_value_proposition_key] = "<i class='coathanger'></i><span>Free Styling Session</span><i class='plane'></i><span>Free delivery in US, CANADA & UK </span><i class='mobile'></i><span>24/7 Customer Service</span>" if Spree::Config[:us_value_proposition_key] == ""
    Spree::Config[:au_value_proposition_key] = "<i class='coathanger'></i><span>Free Styling Session</span><i class='plane'></i><span>Free delivery in AUSTRALIA & NEW ZEALAND </span><i class='mobile'></i><span>24/7 Customer Service</span>" if Spree::Config[:au_value_proposition_key] == ""
  rescue
  end
end

