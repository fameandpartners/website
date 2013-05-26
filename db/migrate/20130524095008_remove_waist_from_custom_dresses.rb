class RemoveWaistFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :waist
  end

  def down
    add_column :custom_dresses, :waist, :string
  end
end
