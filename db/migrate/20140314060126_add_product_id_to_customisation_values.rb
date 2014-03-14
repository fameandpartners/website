class AddProductIdToCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :product_id, :integer
  end
end
