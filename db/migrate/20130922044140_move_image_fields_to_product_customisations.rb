class MoveImageFieldsToProductCustomisations < ActiveRecord::Migration
  def change
    remove_column :customisation_values, :image_file_name
    remove_column :customisation_values, :image_content_type
    remove_column :customisation_values, :image_file_size

    add_column :product_customisation_values, :image_file_name, :string
    add_column :product_customisation_values, :image_content_type, :string
    add_column :product_customisation_values, :image_file_size, :integer
  end
end
