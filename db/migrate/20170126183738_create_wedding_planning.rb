class CreateWeddingPlanning < ActiveRecord::Migration
  def change
    create_table :wedding_plannings do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :preferred_time
      t.string :session_type
      t.boolean :should_contact
      t.boolean :should_receive_trend_updates
      t.string :timezone
      t.date :wedding_date

      t.timestamps
    end
  end
end
