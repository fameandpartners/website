class AddUpcToLineItems < ActiveRecord::Migration
    def up
  	add_column :spree_line_items, :upc, :string
  end

  def down
  	remove_column :spree_line_items, :upc
  end
end
