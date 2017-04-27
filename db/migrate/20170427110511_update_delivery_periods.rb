class UpdateDeliveryPeriods < ActiveRecord::Migration
  def up
    Spree::Taxon.where(delivery_period: '7 - 10 business days').update_all(delivery_period: '8 - 10 business days')
    Spree::Taxon.where(delivery_period: '2 - 4 weeks').update_all(delivery_period: '3 - 4 weeks')
  end

  def down
  end
end
