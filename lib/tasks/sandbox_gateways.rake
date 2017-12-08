namespace :data do
  desc 'Create Sandbox gateways for dev, and qa use. Use after restoring prod db dumps.'
  task create_sandbox_gateways: :environment do

    # disable existing gateways
    Spree::PaymentMethod.all.map do |gw|
      gw.active = false
      gw.save
    end
binding.pry
    afterpay_payment                    = Spree::Gateway::AfterpayPayment.new
    afterpay_payment.name               = 'Afterpay Australia TEST'
    afterpay_payment.preferred_username = '32935' # Sandbox API Keys
    afterpay_payment.preferred_password = '249c235938f36015bb32571721ba2dc80257d2fe985799c30a0e5877408991b596b117d998e0528a7872103f8fc80e07d71163c801b22153149ac6a0919b588a' # Sandbox API Keys
    afterpay_payment.preferred_server   = 'sandbox'
    afterpay_payment.environment        = Rails.env
    afterpay_payment.active             = true
    afterpay_payment.save

    stripe_payment = Spree::Gateway::FameStripe.new
    stripe_payment.name = "Stripe - US Test"
    stripe_payment.preferences[:currency] = 'USD'
    stripe_payment.preferred_api_key = 'sk_test_yW9SNQf6P6xCqkNgBs36jPGr'
    stripe_payment.preferred_publishable_key = 'pk_test_W2TXpgZbnoebFKeDzNW74xhB'
    stripe_payment.preferred_server = 'test'
    stripe_payment.environment = Rails.env
    stripe_payment.preferences[:test_mode] = true
    stripe_payment.active = true
    stripe_payment.save

    stripe_payment = Spree::Gateway::FameStripe.new
    stripe_payment.name = "Stripe - AU Test"
    stripe_payment.preferences[:currency] = 'AUD'
    stripe_payment.preferred_api_key = 'sk_test_CfDYdUzw8Sv6suQyd08HG9Lo'
    stripe_payment.preferred_publishable_key = 'pk_test_ic3pWUfqR66brmOJ01TrE5Lf'
    stripe_payment.preferred_server = 'test'
    stripe_payment.environment = Rails.env
    stripe_payment.preferences[:test_mode] = true
    stripe_payment.active = true
    stripe_payment.save

    paypal_payment = Spree::Gateway::PayPalExpress.new
    paypal_payment.name = "PayPalExpress - USD Test"
    paypal_payment.preferences[:currency] = 'USD'
    paypal_payment.preferred_server = 'sandbox'
    paypal_payment.environment = Rails.env
    paypal_payment.preferences[:login] = 'finance-facilitator_api1.fameandpartners.com'
    paypal_payment.preferences[:password] = '7BJKSRVLMFNAL544'
    paypal_payment.preferences[:signature] = 'AFcWxV21C7fd0v3bYYYRCpSSRl31Aa'
    paypal_payment.preferences[:test_mode] = true
    paypal_payment.active = true
    paypal_payment.save

  end

end
