class AddCustomisationTypeToCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :customisation_type, :string
  end
end
