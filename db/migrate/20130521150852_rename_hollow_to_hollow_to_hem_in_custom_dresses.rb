class RenameHollowToHollowToHemInCustomDresses < ActiveRecord::Migration
  def change
    rename_column :custom_dresses, :hollow, :hollow_to_hem
  end
end
