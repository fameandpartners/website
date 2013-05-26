class AddGhostToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :ghost, :boolean, :default => true
  end
end
