class AddSpreeUserIdToCustomDresses < ActiveRecord::Migration
  def change
    add_column :custom_dresses, :spree_user_id, :integer
  end
end
