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

  def available_states_for_current_zone
    checkout_zone = current_site_version.try(:zone) || Zone.find_by_name(Spree::Config[:checkout_zone])
    if checkout_zone && checkout_zone.kind == 'country'
      countries = checkout_zone.country_list.map(&:id)
      states = Spree::State.where(country_id: countries).sort_by{|state| state.name }
    else
      states = Spree::State.order('name asc').all
    end
  end

  # Not a payment gateway
  def masterpass_active?
    false #|| Features.active?(:masterpass, current_spree_user) || session[:auto_applied_promo_code] == 'masterpass25'
  end

  def masterpass_cart_callback_uri(payment_method)
    callback_protocol = Rails.env.production? ? 'https' : 'http'
    cart_masterpass_url(payment_method_id: payment_method.id, protocol: callback_protocol)
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
