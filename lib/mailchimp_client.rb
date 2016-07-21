class MailchimpClient

  attr_accessor :gibbon

  STORE_ID = 'fame_and_partners'

  def initialize
    self.gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
  end

  def add_customer(user)
    return if customer_exists? user

    user_params = {
      id: user.id.to_s,
      email_address: user.email,
      opt_in_status: false
    }

    gibbon.ecommerce.stores(STORE_ID).customers.create(body: user_params)
  rescue StandardError => e
    Raven.capture_exception(e)
  end

  private

  def customer_exists?(user)
    gibbon.ecommerce.stores(STORE_ID).customers(user.id).retrieve
    true
  rescue Gibbon::MailChimpError => e
    false
  end
end
