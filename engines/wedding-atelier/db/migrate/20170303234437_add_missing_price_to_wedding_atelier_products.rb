class AddMissingPriceToWeddingAtelierProducts < ActiveRecord::Migration
  def change
    aud_currency = Spree::Config["currency"] == 'AUD'

    products = [
      { name: 'Column', aud_amount: 249, usd_amount: 199 },
      { name: 'Fit and Flare', aud_amount: 249, usd_amount: 199 },
      { name: 'Shift', aud_amount: 249, usd_amount: 199 },
      { name: 'Slip', aud_amount: 249, usd_amount: 199 },
      { name: 'Wrap', aud_amount: 249, usd_amount: 199 },
      { name: 'Tri-Cup', aud_amount: 249, usd_amount: 199 },
      { name: 'Set', aud_amount: 279, usd_amount: 219 },
      { name: 'Multi Way', aud_amount: 279, usd_amount: 219 }
    ]

    products.each do |p|
      missing_currency = aud_currency ? 'USD': 'AUD'
      missing_amount = aud_currency ? p[:usd_amount] : p[:aud_amount]
      current_amount = p["#{Spree::Config['currency'].downcase}_amount".to_sym]
      # Using try because this could break in some development environments as
      # the migration may be run after actually running wedding_atelier:populate_products
      variants = Spree::Product.where(name: p[:name]).first.try(:variants_including_master) || []
      variants.each do |variant|
        current_price = variant.prices.where(currency: Spree::Config["currency"]).first
        # fix current price since it may be AUD with USD amount
        current_price.update_attribute(:amount, current_amount)
        variant.prices.create({currency: missing_currency, amount: missing_amount})
     end
   end
  end
end
