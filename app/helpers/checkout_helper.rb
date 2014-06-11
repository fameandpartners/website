module CheckoutHelper
  # updated code from spree::base_helper#available_countries
  def available_countries_for_current_zone
    checkout_zone = current_site_version.try(:zone) || Zone.find_by_name(Spree::Config[:checkout_zone])

    if checkout_zone && checkout_zone.kind == 'country'
      countries = checkout_zone.country_list
    else
      countries = Spree::Country.all
    end 

    countries.collect do |country|
      country.name = I18n.t(country.iso, :scope => 'country_names', :default => country.name)
      country
    end.sort { |a, b| a.name <=> b.name }
  end 

  def payment_failed_messages(error)

    case error.downcase.gsub(/[^a-z ]/, "")
    when /the card was declined/
      save_purchase = true
    when /there are not enough funds available to process the requested amount/
      save_purchase = true
    when /the transaction was flagged as possibly fraudulent and subsequently declined/
      save_purchase = true
    when /the card has expired/
      save_purchase = true
    when /an error occurred while processing the card/
      save_purchase = true
    else
      save_purchase = false
    end

    if save_purchase == true
      return true
    else
      return false
    end

  end
end
