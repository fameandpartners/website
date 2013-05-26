class RemoveHipsFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :hips
  end

  def down
    add_column :custom_dresses, :hips, :string
  end
end
