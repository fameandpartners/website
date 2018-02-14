class ReturnInventoryItem < ActiveRecord::Base
  attr_accessible :upc, :style_number, :available, :vendor

  def self.truncate!
    connection.execute("truncate table return_inventory_items")
    ActiveRecord::Base.connection.reset_pk_sequence!('return_inventory_items')
  end

end
