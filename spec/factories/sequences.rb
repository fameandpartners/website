FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :first_name do |n|
    "first_name_#{ n }"
  end

  sequence :last_name do |n|
    "last_name_#{ n }"
  end
end
