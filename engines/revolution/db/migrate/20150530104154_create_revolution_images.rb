class CreateRevolutionImages < ActiveRecord::Migration
  def change
    create_table :revolution_images do |t|
      t.text    :name, :nil => false
      t.timestamps
    end

    # add_index :revolution_translations_images, :image_id

    create_table :revolution_translation_images do |t|
      t.integer :translation_id, :nil => false
      t.integer :image_id, :nil => false
      t.timestamps
    end
    #
    # add_index :revolution_translation_images, :translation_id
    # add_index :revolution_translation_images, :image_id

  end
end
