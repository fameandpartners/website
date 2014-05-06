Spree::Address.class_eval do
  attr_accessible :email

  def self.default(site_version = nil)
    if site_version.present?
      country = site_version.default_country || site_version.countries.first
    end

    country ||= Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
    new({:country => country}, :without_protection => true)
  end

  def to_string
    [
      [address1, address2].reject(&:blank?).join(' '),
      city,
      state.try(:name),
      zipcode,
      country.try(:name)
    ].reject(&:blank?).join(', ')
  end
end
