class AddImageAndProductionCodeToFabric < ActiveRecord::Migration
  def change
    add_column :fabrics, :production_code, :string
    
    add_column :fabrics, :image_file_name, :string
    add_column :fabrics, :image_content_type, :string
    add_column :fabrics, :image_file_size, :integer
    add_column :fabrics, :image_updated_at, :datetime
  end
end
