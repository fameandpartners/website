class RemoveEmailFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :email
  end

  def down
    add_column :custom_dresses, :email, :string
  end
end
