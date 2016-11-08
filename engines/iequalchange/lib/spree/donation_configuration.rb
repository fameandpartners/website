class Spree::DonationConfiguration < Spree::Preferences::Configuration
	preference :enabled, :boolean, default: true
	preference :site_id, :string
	preference :site_key, :string
	preference :site_url, :string, :default => 'https://share.iequalchange.com/'
	preference :id_lookup, :string, :default => '#order_summary'
end

class Spree::Donation
end

module Spree
	Donation::Config = Spree::DonationConfiguration.new
end

#Online Store specific configuration file.
Spree::Donation::Config[:site_url] = 'https://iec-staging.3dc.com.au/'
Spree::Donation::Config[:site_id] = ''
Spree::Donation::Config[:site_key] = ''
