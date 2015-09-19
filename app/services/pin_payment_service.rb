class PinPaymentService

  attr_reader :opts, :charge, :error

  # {
  # email:       customer.email,
  # amount:      1000,
  # currency:    'USD', # only AUD and USD are supported by pin.net.au
  # description: 'Widgets',
  # ip_address:  request.ip,
  # card:        {
  #   number:           5520000000000000,
  #   expiry_month:     5,
  #   expiry_year:      2014,
  #   cvc:              123,
  #   name:             'Roland Robot',
  #   address_line1:    '42 Sevenoaks St',
  #   address_city:     'Lathlain',
  #   address_postcode: 6454,
  #   address_state:    'WA',
  #   address_country:  'Australia'
  # }

  def initialize(pin_api_key, opts)
    PinPayment.secret_key = pin_api_key
    @opts = opts
  end

  def create_charge
    begin
      @charge = PinPayment::Charge.create(opts)
    rescue PinPayment::Error::InvalidResource => e
      handle_error(e)
      false
    end
  end

  def has_error?
    @error.present?
  end

  def has_ok?
    @error.blank?
  end

  def handle_error(e)
    @error = e.message
    Rails.logger.error('PIN PAYMENT ERROR')
    Rails.logger.error(e)
    NewRelic::Agent.notice_error(e)
    NewRelic::Agent.notify('PinPaymentFailed', message: e.message, opts: opts)
  end
end
