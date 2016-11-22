class RolifyCreateEventRoles < ActiveRecord::Migration
  def change
    create_table(:event_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:spree_users_event_roles, :id => false) do |t|
      t.references :user
      t.references :event_role
    end

    add_index(:event_roles, :name)
    add_index(:event_roles, [ :name, :resource_type, :resource_id ])
    add_index(:spree_users_event_roles, [ :user_id, :event_role_id ])
  end
end
