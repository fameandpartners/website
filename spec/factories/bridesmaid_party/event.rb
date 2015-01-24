FactoryGirl.define do
  factory :bridesmaid_party_event, class: BridesmaidParty::Event do
  end

  factory :completed_bridesmaid_party_event, class: BridesmaidParty::Event do
    wedding_date { rand(10).next.months.from_now }
    status       { BridesmaidParty::Event::STATUSES.first.first }
    bridesmaids_count { rand(10) }
    colors       [{:group=>"blue", :ids=>[28, 72, 79, 73, 70, 162, 170]}]
    additional_products [:consierge_service]
    paying_for_bridesmaids true
  end
end
