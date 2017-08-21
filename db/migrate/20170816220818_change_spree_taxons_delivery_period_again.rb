class ChangeSpreeTaxonsDeliveryPeriodAgain < ActiveRecord::Migration
  def up
    change_column :spree_taxons, :delivery_period, :string, :default => "7 - 10 business days"

    count = 0
    Spree::Taxon.where(delivery_period: "7 business days").each do |taxy|
      taxy.delivery_period = "7 - 10 business days"
      taxy.save
      count = count + 1
    end
    p "Taxons changed: #{count}"
  end

  def down
    change_column :spree_taxons, :delivery_period, :string, :default => "7 business days"

    Spree::Taxon.where(delivery_period: "7 - 10 business days").each do |taxy|
      taxy.delivery_period = "7 - 10 business days"
      taxy.save
    end
  end
end
