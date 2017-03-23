class AddSitewideMessageToSpreeSale < ActiveRecord::Migration
  def change
    add_column :spree_sales, :sitewide_message, :string
  end
end
