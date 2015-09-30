class AddValuePropositionPreference < ActiveRecord::Migration
  def up
    if SiteVersion.where(permalink: 'au').exists?
      Spree::Config[:au_value_proposition_key] = "<i class='coathanger'></i><span>Free Styling Session</span><i class='plane'></i><span>Free delivery in AUSTRALIA & NEW ZEALAND</span><i class='mobile'></i><span>24/7 Customer Service</span>"
    end

    if SiteVersion.where(permalink: 'us').exists?
      Spree::Config[:us_value_proposition_key] = "<i class='coathanger'></i><span>Free Styling Session</span><i class='plane'></i><span>Free delivery in US, CANADA & UK</span><i class='mobile'></i><span>24/7 Customer Service</span>"
    end
  rescue StandardError => e
    say "Value Proposition migration failed: #{e.message}"
  end

  def down
    # NOOP
  end
end
