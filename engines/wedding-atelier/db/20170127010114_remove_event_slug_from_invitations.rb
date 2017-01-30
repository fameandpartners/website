class RemoveEventSlugFromInvitations < ActiveRecord::Migration
  def up
    remove_column :wedding_atelier_invitations, :event_slug
  end

  def down
    add_column :wedding_atelier_invitations, :event_slug, :string
  end
end
