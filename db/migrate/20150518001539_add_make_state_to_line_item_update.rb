class AddMakeStateToLineItemUpdate < ActiveRecord::Migration
  def change
    add_column :line_item_updates, :make_state, :string
    add_column :line_item_updates, :raw_line_item, :string
    add_column :line_item_updates, :setup_ship_errors, :text, array:true
  end
end
