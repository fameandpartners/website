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

  sequence :name do |n|
    "some_name_#{ n }"
  end

  sequence :permalink do |n|
    "some_permalink_#{ n }"
  end

  sequence :utm_campaign do |n|
    "utm_campaign_#{ n }"
  end
end
