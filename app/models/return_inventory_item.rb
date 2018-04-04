class ReturnInventoryItem < ActiveRecord::Base
  attr_accessible :upc, :style_number, :available, :vendor

  def self.deactivate_all_records!(vendor)
    connection.execute("UPDATE return_inventory_items SET active=false where vendor='#{vendor}'")
  end

end
