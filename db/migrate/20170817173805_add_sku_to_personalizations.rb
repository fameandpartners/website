class AddSkuToPersonalizations < ActiveRecord::Migration
  def change
  	add_column :line_item_personalizations, :width, :string, :null => true, :limit => 128 
  end
end
