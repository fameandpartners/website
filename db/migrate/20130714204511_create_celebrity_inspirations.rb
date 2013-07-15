class CreateCelebrityInspirations < ActiveRecord::Migration
  def change
    create_table :celebrity_inspirations, force: true do |t|
      t.references :spree_product

      t.string   :celebrity_name

      t.string   :photo_file_name
      t.string   :photo_content_type
      t.integer  :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
  end
end
