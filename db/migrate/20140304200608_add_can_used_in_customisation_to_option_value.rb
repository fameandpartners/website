class AddCanUsedInCustomisationToOptionValue < ActiveRecord::Migration
  def change
    add_column :spree_option_values, :use_in_customisation, :boolean, default: false
  end
end
