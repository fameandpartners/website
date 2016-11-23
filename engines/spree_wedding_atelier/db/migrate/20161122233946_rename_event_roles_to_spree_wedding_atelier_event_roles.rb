class RenameEventRolesToSpreeWeddingAtelierEventRoles < ActiveRecord::Migration
  def up
    rename_table :event_roles, :spree_wedding_atelier_event_roles
  end

  def down
    rename_table :spree_wedding_atelier_event_roles, :event_roles
  end
end
