# run with 
# RAILS_ENV=production bundle exec rake db:migrate:with_data
#
class UpdateUsZoneWithCanadaAndUk < ActiveRecord::Migration
  def self.up
    us_version = SiteVersion.by_permalink_or_default('en')

    add_country_with_states(us_version, "UNITED KINGDOM")
    add_country_with_states(us_version, "CANADA")
  end

  def self.down
  end

  private

    def self.add_country_with_states(site_version, country_iso_name)
      country = Spree::Country.where(iso_name: country_iso_name).first

      if country.blank?
        raise "can't found country #{ country_iso_name }"
      end

      ensure_country_is_zone_member(site_version, country)
      ensure_country_has_states(country)
    end

    def self.ensure_country_is_zone_member(site_version, country)
      site_version.zone.members.where(
        zoneable_id: country.id,
        zoneable_type: country.class.to_s
      ).first_or_create
    end

    def self.ensure_country_has_states(country)
      states = get_states_for_country(country.iso)

      states.each do |abbr, name|
        state = country.states.where(abbr: abbr).first_or_initialize
        state.name = name
        state.save
      end
    end

    # GB
    # CA
    def self.get_states_for_country(country_iso_code)
      if country_iso_code == 'CA'
        [
          ["AB", "Alberta"],
          ["BC", "British "],
          ["MB", "Manitoba"],
          ["NB", "New "],
          ["NL", "Newfoundland "],
          ["NS", "Nova "],
          ["ON", "Ontario"],
          ["PE", "Prince "],
          ["QC", "Quebec"],
          ["SK", "Saskatchewan"],
          ["NT", "Northwest "],
          ["NU", "Nunavut"],
          ["YT", "Yukon"],
        ]
      else
        []
      end
    end
end
