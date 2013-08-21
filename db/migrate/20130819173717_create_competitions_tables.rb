class CreateCompetitionsTables < ActiveRecord::Migration
  def change
    create_table :competition_invitations, force: true do |t|
      t.references :user

      t.string     :token, limit: 50
      t.string     :email
      t.string     :name
      t.string     :invitation_type, limit: 50

      t.datetime   :created_at
    end

    create_table :competition_entries, force: true do |t|
      t.references  :user
      t.references  :inviter
      t.references  :invitation

      t.boolean     :master, default: false

      t.datetime    :created_at
    end

    # add index :user, inviter, token
  end

#  def down
#    drop_table :competition_invitations
#    drop_table :competition_entries
#  end
end
