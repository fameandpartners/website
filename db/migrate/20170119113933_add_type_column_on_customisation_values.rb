class AddTypeColumnOnCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :customisation_type, :string, default: 'cut'
  end
end
