# This migration comes from wedding_atelier (originally 20161123005430)
class CreateWeddingAtelierEventAssistants < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_event_assistants do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
      t.timestamps
    end
  end

  def down
    drop_table :wedding_atelier_event_assistants
  end
end
