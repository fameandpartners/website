class CreateWeddingPlanning < ActiveRecord::Migration
  def change
    create_table :wedding_planning do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :preferred_time
      t.string :session_type
      t.boolean :should_contact
      t.string :timezone
      t.date :wedding_date

      t.timestamps
    end
  end
end
