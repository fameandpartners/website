class CreateStyleImages < ActiveRecord::Migration
  def change
    create_table :style_images do |t|
      t.references :style

      t.integer   :position
      t.boolean   :active, default: true

      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end

    remove_column :styles, :image_file_name
    remove_column :styles, :image_content_type
    remove_column :styles, :image_file_size
    remove_column :styles, :image_updated_at
  end
end
