FactoryGirl.define do
  factory :bridesmaid_party_member, class: BridesmaidParty::Member do
    first_name { generate(:first_name) }
    last_name  { generate(:last_name) }
    email      { generate(:email) }
    token      { SecureRandom.urlsafe_base64(24) }
  end
end
