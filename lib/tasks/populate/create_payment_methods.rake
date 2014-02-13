namespace "db" do
  namespace "populate" do
    desc "create base payment methods: test credit card, paypal sandbox"
    task payment_methods: :environment do
      add_paypal_express_payment_method
    end
  end
end

def add_paypal_express_payment_method
  payment_method  = Spree::Gateway::PayPalExpress.where(environment: Rails.env.to_s).first_or_initialize

  payment_method.name ||= 'Paypal Express Test Method / ( Ilnur )'
  payment_method.active = true
  payment_method.deleted_at = nil

  payment_method.preferred_login      = 'ilnur.yakupov-facilitator_api1.gmail.com'
  payment_method.preferred_password   = '1380521827'
  payment_method.preferred_signature  = 'Ai1PaghZh5FmBLCDCTQpwG8jB264AKnaMWOLts9RJUv5mcBreRpxIV09'
  payment_method.preferred_server     = 'sandbox'

  payment_method.save
  puts "Paypal Express Payment method id: #{ payment_method.id }"
  payment_method
end
