class CreateWeddingAtelierEvents < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_events do |t|
      t.string  :event_type
      t.integer :number_of_assistants
      t.date    :date
      t.string  :name
      t.string  :slug, index: true
      t.timestamps
    end
  end

  def down
    drop_table :wedding_atelier_events
  end
end
