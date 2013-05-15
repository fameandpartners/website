class CreateCustomDressImages < ActiveRecord::Migration
  def change
    create_table :custom_dress_images do |t|
      t.references :custom_dress
      t.has_attached_file :file

      t.timestamps
    end
  end
end
