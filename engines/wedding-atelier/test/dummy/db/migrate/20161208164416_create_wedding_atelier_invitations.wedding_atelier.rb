# This migration comes from wedding_atelier (originally 20161125233314)
class CreateWeddingAtelierInvitations < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_invitations do |t|
      t.string :user_email
      t.string :event_slug
      t.string :state, default: 'pending'
    end
  end

  def down
    drop_table :wedding_atelier_invitations
  end
end
