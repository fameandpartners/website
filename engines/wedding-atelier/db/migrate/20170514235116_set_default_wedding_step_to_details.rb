class SetDefaultWeddingStepToDetails < ActiveRecord::Migration
  def up
    change_column :spree_users, :wedding_atelier_signup_step, :string, default: "details"
  end

  def down
    change_column :spree_users, :wedding_atelier_signup_step, :string, default: "size"
  end
end
