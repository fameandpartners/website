class AddLineItemNameToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :curation_name, :text
  end
end
