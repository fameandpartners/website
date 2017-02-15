class AddPointOfViewToCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :point_of_view, :string
  end
end
