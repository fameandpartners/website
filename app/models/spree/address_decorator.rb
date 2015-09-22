Spree::Address.class_eval do
  attr_accessible :email

  def self.default(site_version = nil, country_code = nil)

    if site_version.present?
      #use country code from session?
      if country_code.present? && country_code.downcase != site_version.code
        country = Spree::Country.find_by_iso(country_code)
      else
        country = site_version.default_country || site_version.countries.first
      end
    end

    country ||= Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
    new({:country => country}, :without_protection => true)
  end

  def to_s
    [
      [address1, address2].reject(&:blank?).join(' '),
      city,
      state.try(:name),
      zipcode,
      country.try(:name)
    ].reject(&:blank?).join(', ')
  end
end
