class RemoveBustFromCustomDresses < ActiveRecord::Migration
  def up
    remove_column :custom_dresses, :bust
  end

  def down
    add_column :custom_dresses, :bust, :string
  end
end
