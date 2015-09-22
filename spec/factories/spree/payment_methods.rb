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

    factory :masterpass_gateway, parent: :payment_method, class: 'Spree::Gateway::Masterpass' do
      after :create do |instance|
        # valid sandbox data, but we need valid csr file too
        instance.preferred_checkout_identifier = 'a4a6x1ywxlkxzhensyvad1hepuouaesuv'
        instance.preferred_consumer_key = 'cLb0tKkEJhGTITp_6ltDIibO5Wgbx4rIldeXM_jRd4b0476c!414f4859446c4a366c726a327474695545332b353049303d'
        instance.preferred_server           = 'test'
        instance.preferred_test_mode        = true
      end
    end
  end
end
