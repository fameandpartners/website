class AddShippingMessagePreference < ActiveRecord::Migration
  def up
    if SiteVersion.where(permalink: 'au').exists?
      Spree::Config[:au_shipping_message_key] = "Please note there will be no shipping between the 1st-10th October due to international public holidays."
    end

    if SiteVersion.where(permalink: 'us').exists?
      Spree::Config[:us_shipping_message_key] = "Please note there will be no shipping between the 1st-10th October due to international public holidays."
    end
  rescue StandardError => e
    say "Shipping Message migration failed: #{e.message}"
  end

  def down
    # NOOP
  end
end
