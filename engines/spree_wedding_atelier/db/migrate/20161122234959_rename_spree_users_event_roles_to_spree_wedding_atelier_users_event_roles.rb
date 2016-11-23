class RenameSpreeUsersEventRolesToSpreeWeddingAtelierUsersEventRoles < ActiveRecord::Migration
  def up
    rename_table :spree_users_event_roles, :spree_users_spree_wedding_atelier_event_roles
  end

  def down
    rename_table  :spree_users_spree_wedding_atelier_event_roles, :spree_users_event_roles
  end
end
