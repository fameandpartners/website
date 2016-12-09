# This migration comes from wedding_atelier (originally 20161121185106)
class AddWeddingAtelierSignupStepToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :wedding_atelier_signup_step, :string, default: 'size'
  end
end
