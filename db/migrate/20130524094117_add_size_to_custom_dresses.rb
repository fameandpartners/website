class AddSizeToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :size, :string
  end
end
