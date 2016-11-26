class CreateSpreeWeddingAtelierInvitations < ActiveRecord::Migration
  def up
    create_table :spree_wedding_atelier_invitations do |t|
      t.string :user_email
      t.string :event_slug
    end
  end

  def down
    drop_table :spree_wedding_atelier_invitations
  end
end
