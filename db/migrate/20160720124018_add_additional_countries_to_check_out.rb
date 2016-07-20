class AddAdditionalCountriesToCheckOut < ActiveRecord::Migration

  US_ZONE_COUNTRY_NAMES = ['Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia',
                           'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania',
                           'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia',
                           'Spain', 'Sweden', 'United Kingdom', 'United Arab Emirates', 'Saudi Arabia', 'Russian Federation',
                           'Israel', 'Puerto Rico']

  AUSTRALIA_ZONE_COUNTRY_NAMES = ['Hong Kong', 'Malaysia', 'Japan', 'Singapore', 'China']

  AUSTRALIA_ZONE = Spree::Zone.find(3)
  US_ZONE = Spree::Zone.find(4)

  def up
    AUSTRALIA_ZONE_COUNTRY_NAMES.each { |country_name| add_country_to_zone(AUSTRALIA_ZONE, country_name) }

    US_ZONE_COUNTRY_NAMES.each { |country_name| add_country_to_zone(US_ZONE, country_name) }

    update_zone_members_counter(AUSTRALIA_ZONE)
    update_zone_members_counter(US_ZONE)
  end

  def down
    US_ZONE_COUNTRY_NAMES.each { |country_name| remove_country_from_zone(US_ZONE, country_name) }
    AUSTRALIA_ZONE_COUNTRY_NAMES.each { |country_name| remove_country_from_zone(AUSTRALIA_ZONE, country_name) }

    update_zone_members_counter(AUSTRALIA_ZONE)
    update_zone_members_counter(US_ZONE)
  end

  def add_country_to_zone(zone, country_name)
    country = Spree::Country.where(name: country_name).first
    raise "Country #{country_name} not found" unless country
    if zone.members.map(&:zoneable_id).include? country.id
      puts "#{country.name} already in the #{zone.name} zone"
      zone_member = zone.members.where(zoneable_id: country.id).first
      zone_member.has_international_shipping_fee = true
      zone_member.save!
    else
      zone.members.create!(zoneable_id: country.id, zoneable_type: 'Spree::Country', has_international_shipping_fee: true)
    end
  end

  def remove_country_from_zone(zone, country_name)
    country = Spree::Country.where(name: country_name).first
    raise "Country #{country_name} not found" unless country

    zone_member = zone.members.where(zoneable_id: country.id).first
    zone_member.destroy if zone_member
  end

  def update_zone_members_counter(zone)
    zone.zone_members_count = zone.zone_members.size
    zone.save!
  end
end
