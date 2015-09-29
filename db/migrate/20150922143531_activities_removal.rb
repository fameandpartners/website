class ActivitiesRemoval < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.index_exists? :activities, [:action, :owner_type, :owner_id]
      remove_index  :activities, [:action, :owner_type, :owner_id]
    end

    if ActiveRecord::Base.connection.table_exists? :activities
      drop_table :activities
    end
  end

  def down
    create_table :activities, force: true do |t|
      t.string :action
      t.integer :number
      t.string :session_key

      # product
      t.string :owner_type
      t.references :owner

      # user
      t.string :actor_type
      t.references :actor

      # action
      t.string :item_type
      t.references :item

      # serializable field
      t.text :info

      t.timestamps
    end
    
    # create indexes
    if !ActiveRecord::Base.connection.index_exists? :activities, [:action, :owner_type, :owner_id]
      add_index  :activities, [:action, :owner_type, :owner_id]
    end
  end
end
