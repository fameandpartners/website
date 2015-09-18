FactoryGirl.define do
  factory :payment_method, class: 'Spree::PaymentMethod' do
    environment 'test'
    active      true
    name        'payment gateway default'
    display_on  ''
    description ''

    factory :pin_gateway, parent: :payment_method, class: 'Spree::Gateway::Pin' do
      name "PIN Payments TEST"

      after :create do |instance|
        instance.preferred_api_key          = 'LElcjB_z4BItXJQPYlw43g'
        instance.preferred_publishable_key  = 'pk_iaPOLVAQMh7nTJ0WhECpUA'
        instance.preferred_server           = 'test'
        instance.preferred_test_mode        = true
      end
    end
  end
end
