class RemoveFirstNameFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :first_name
  end

  def down
    add_column :custom_dresses, :first_name, :string
  end
end
