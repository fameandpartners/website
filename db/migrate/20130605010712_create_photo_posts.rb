class CreatePhotoPosts < ActiveRecord::Migration
  def change
    create_table :photo_posts do |t|
      t.integer :photo_uploaddable_id
      t.integer :photo_id
      t.string :photo_uploaddable_type

      t.timestamps
    end
    add_index :photo_posts, [:photo_uploaddable_id, :photo_uploaddable_type, :photo_id],
      :unique => true, name: 'index_photo_uploaddable'

  end
end
