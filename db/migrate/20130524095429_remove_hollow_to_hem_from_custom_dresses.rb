class RemoveHollowToHemFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :hollow_to_hem
  end

  def down
    add_column :custom_dresses, :hollow_to_hem, :string
  end
end
