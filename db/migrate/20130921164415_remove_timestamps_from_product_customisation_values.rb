class RemoveTimestampsFromProductCustomisationValues < ActiveRecord::Migration
  def change
    remove_column :product_customisation_values, :created_at
    remove_column :product_customisation_values, :updated_at
  end
end
