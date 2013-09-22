class CreateCustomisationTypes < ActiveRecord::Migration
  def change
    create_table :customisation_types do |t|
      t.integer :position
      t.string :name
      t.string :presentation

      t.timestamps
    end

    create_table :customisation_values do |t|
      t.integer :position
      t.string :name
      t.string :presentation
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.references :customisation_type

      t.timestamps
    end

    create_table :product_customisation_types do |t|
      t.references :product
      t.references :customisation_type

      t.timestamps
    end

    create_table :product_customisation_values do |t|
      t.references :product_customisation_types
      t.references :customisation_value

      t.timestamps
    end
  end
end
