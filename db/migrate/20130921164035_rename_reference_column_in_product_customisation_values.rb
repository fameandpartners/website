class RenameReferenceColumnInProductCustomisationValues < ActiveRecord::Migration
  def change
    rename_column :product_customisation_values, :product_customisation_types_id, :product_customisation_type_id
  end
end
