# This migration comes from wedding_atelier (originally 20161122172949)
class RolifyCreateEventRoles < ActiveRecord::Migration
  def change
    create_table(:wedding_atelier_event_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:wedding_atelier_users_event_roles, :id => false) do |t|
      t.references :user
      t.references :event_role
    end
  end
end
