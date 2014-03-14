class RemoveCustomisationTypeIdFromCustomisationValues < ActiveRecord::Migration
  def up
    remove_column :customisation_values, :customisation_type_id
  end

  def down
    add_column :customisation_values, :customisation_type_id, :integer
  end
end
