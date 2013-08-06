namespace "db" do
  namespace "populate" do
    desc "configure spree seo options"
    task seo: :environment do
      update_base_configuration
    end
  end
end

def default_settings
  {
    always_put_site_name_in_title:  false,
    site_name:                      'Fame & Partners',
    default_seo_title:              "Fame & Partners - Dream Formal Dresses",
    default_meta_description:       "Fame & Partners is committed to bringing the world of celebrity fashion to you. We offer our customers the opportunity to create a look that they love, that is unique to them and will ensure they feel like a celebrity on their special night."
  }
end

def update_base_configuration
  default_settings.each do |key, value|
    Spree::Config[key.to_sym] = value
  end
end

