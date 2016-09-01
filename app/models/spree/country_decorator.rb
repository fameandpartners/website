Spree::Country.class_eval do

  has_one :zone_member, as: :zoneable

end
