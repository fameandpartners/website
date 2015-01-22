FactoryGirl.define do
  factory :spree_user, :class => Spree::User do
    first_name  'Blah'
    last_name   'Vtha III'
    email       'blah@vtha.com'
    password    'password!'
  end
end