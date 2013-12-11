class CreateCelebrityImages < ActiveRecord::Migration
  def change
    create_table :celebrity_images do |t|
      t.integer :celebrity_id
      t.has_attached_file :file
      t.boolean :is_primary, default: false
      t.integer :position
    end

    add_index :celebrity_images, :celebrity_id
    add_index :celebrity_images, :is_primary
  end
end
