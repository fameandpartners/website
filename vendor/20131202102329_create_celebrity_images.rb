class CreateCelebrityImages < ActiveRecord::Migration
  def change
    create_table :celebrity_images do |t|
      t.integer :celebrity_id
    end
  end
end
