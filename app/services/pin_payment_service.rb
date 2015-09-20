class PinPaymentService

  attr_reader :opts, :charge, :error

  def initialize(pin_api_key, opts)
    PinPayment.secret_key = pin_api_key
    @opts = opts
  end

  def create_charge
    begin
      @charge = PinPayment::Charge.create(opts)      
    rescue PinPayment::Error => e
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
