class CreateCompetitionParticipations < ActiveRecord::Migration
  def change
    create_table :competition_participations do |t|
      t.integer :spree_user_id
      t.string :token
      t.integer :shares_count, default: 0
      t.integer :views_count, default: 0

      t.timestamps
    end
  end
end
