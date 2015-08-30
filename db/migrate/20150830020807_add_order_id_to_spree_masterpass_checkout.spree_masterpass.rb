# This migration comes from spree_masterpass (originally 20150829092221)
class AddOrderIdToSpreeMasterpassCheckout < ActiveRecord::Migration
  def change
    add_column :spree_masterpass_checkouts, :order_id, :integer
  end
end
