class AddImageToCustomisationValues < ActiveRecord::Migration
  def change
    add_column :customisation_values, :image_file_name, :string
    add_column :customisation_values, :image_content_type, :string
    add_column :customisation_values, :image_file_size, :integer
  end
end
