class CreateSpreeWeddingAtelierEventAssistants < ActiveRecord::Migration
  def up
    create_table :spree_wedding_atelier_event_assistants do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event, index: true
      t.timestamps
    end
  end

  def down
    drop_table :spree_wedding_atelier_event_assistants
  end
end
