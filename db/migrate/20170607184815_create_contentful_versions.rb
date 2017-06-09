class CreateContentfulVersions < ActiveRecord::Migration
  def change
    create_table :contentful_versions do |t|
      t.string :change_message, :limit => 255
      t.text :payload
      t.integer :user_id
      t.boolean :is_live, default: false

      t.timestamps
    end

    #add_index :contentful_versions, :is_live
  end
end
