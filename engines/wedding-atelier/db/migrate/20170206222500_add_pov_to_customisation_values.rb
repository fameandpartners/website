class AddPovToCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :pov, :string, default: 'front'
  end
end
