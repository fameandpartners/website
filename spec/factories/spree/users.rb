FactoryGirl.define do
  factory :spree_user, class: Spree::User do
    first_name { generate(:first_name) }
    last_name  { generate(:last_name) }
    email      { generate(:email) }
    password                'password!'
    password_confirmation   'password!'
    skip_welcome_email true
  end
end
