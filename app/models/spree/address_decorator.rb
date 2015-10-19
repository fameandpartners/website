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

  def set_last(current_user=nil, current_order)
    if current_user && !current_order.try(:bill_address)
      last_order = Spree::Order.with_state(:complete).where(user_id: current_user).order(:created_at).last
      order_bill_address = last_order.bill_address if last_order.try(:bill_address)
    end
    order_bill_address = current_order.bill_address if current_order.try(:bill_address)

    if order_bill_address.present?
      self.address1 = order_bill_address.address1
      self.address2 = order_bill_address.address2
      self.city = order_bill_address.city
      self.state_id = order_bill_address.state_id
      self.country_id = order_bill_address.country_id
      self.zipcode = order_bill_address.zipcode
      self.phone = order_bill_address.phone
    end
  end
end
