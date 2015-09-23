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

  def set_last(current_user=nil, try_spree, current_order)
    if try_spree && !current_order.try(:bill_address)
      last_order = Spree::Order.with_state(:complete).where(user_id: current_user).order(:created_at).last
      order = last_order.bill_address if last_order.try(:bill_address)
    end
    order = current_order.bill_address if current_order.try(:bill_address)

    if order.present?
      self.address1 = order.address1
      self.address2 = order.address2
      self.city = order.city
      self.state_id = order.state_id
      self.country_id = order.country_id
      self.zipcode = order.zipcode
      self.phone = order.phone
    end
  end
end
