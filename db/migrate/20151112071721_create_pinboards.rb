class CreatePinboards < ActiveRecord::Migration
  def change
    create_table :pinboards do |t|
      t.references :user
      t.string :name
      t.string :purpose
      t.date :event_date
      t.text :description

      t.timestamps
    end
    add_index :pinboards, :user_id
  end
end
