class CreateProductPersonalizations < ActiveRecord::Migration
  def change
    create_table :product_personalizations do |t|
      t.integer :variant_id
      t.integer :line_item_id
      t.integer :user_id
      t.string :user_first_name
      t.string :user_last_name
      t.string :user_email
      t.boolean :change_color
      t.boolean :change_hem_length
      t.boolean :change_neck_line
      t.boolean :change_fabric_type
      t.boolean :merge_styles
      t.boolean :add_beads_or_sequins
      t.text :comments

      t.timestamps
    end
  end
end
