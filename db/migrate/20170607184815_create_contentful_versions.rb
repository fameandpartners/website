class CreateContentfulVersions < ActiveRecord::Migration
  def change
    create_table :contentful_versions do |t|
      t.string :change_message, :limit => 255
      t.text :contentful_payload
      t.integer :user_id
      t.boolean :is_live

      t.timestamps
    end
  end
end
