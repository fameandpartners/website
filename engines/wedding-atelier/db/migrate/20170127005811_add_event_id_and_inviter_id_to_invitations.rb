class AddEventIdAndInviterIdToInvitations < ActiveRecord::Migration
  def change
    add_column :wedding_atelier_invitations, :event_id, :integer
    add_column :wedding_atelier_invitations, :inviter_id, :integer
  end
end
