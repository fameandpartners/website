class RemoveLastNameFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :last_name
  end

  def down
    add_column :custom_dresses, :last_name, :string
  end
end
