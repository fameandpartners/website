class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities, force: true do |t|
      t.string :action
      t.integer :number

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
    add_index  :activities, [:action, :owner_type, :owner_id]
  end
end
