Spree::Address.class_eval do
  def self.default(site_version = nil)
    if site_version.present?
      country = site_version.default_country || site_version.countries.first
    end

    country ||= Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
    new({:country => country}, :without_protection => true)
  end

  def to_string
    [zipcode, country.try(:name), state.try(:name), city, address1, address2].reject(&:blank?).join(', ')
  end
end
