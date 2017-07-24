class CreateItemReturnLabels < ActiveRecord::Migration
  def change
    create_table :item_return_labels do |t|
      t.string :label_url
      t.string :carrier
      t.string :label_image_url
      t.string :label_pdf_url
      t.integer :item_return_id

      t.timestamps
    end
  end
end
