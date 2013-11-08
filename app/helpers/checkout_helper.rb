module CheckoutHelper
  # updated code from spree::base_helper#available_countries
  def available_countries_for_current_zone
    checkout_zone = current_site_version.try(:zone) || Zone.find_by_name(Spree::Config[:checkout_zone])

    if checkout_zone && checkout_zone.kind == 'country'
      countries = checkout_zone.country_list
    else
      countries = Country.all
    end 

    countries.collect do |country|
      country.name = I18n.t(country.iso, :scope => 'country_names', :default => country.name)
      country
    end.sort { |a, b| a.name <=> b.name }
  end 
end
