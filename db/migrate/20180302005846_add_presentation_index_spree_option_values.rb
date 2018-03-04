class AddPresentationIndexSpreeOptionValues < ActiveRecord::Migration
  def change
    add_index :spree_option_values, [:presentation]
  end
end
