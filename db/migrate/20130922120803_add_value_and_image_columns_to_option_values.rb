class AddValueAndImageColumnsToOptionValues < ActiveRecord::Migration
  def change
    add_column :spree_option_values, :value, :string
    add_column :spree_option_values, :image_file_name, :string
    add_column :spree_option_values, :image_content_type, :string
    add_column :spree_option_values, :image_file_size, :integer
  end
end
