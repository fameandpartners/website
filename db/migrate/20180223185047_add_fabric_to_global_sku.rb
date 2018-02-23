class AddFabricToGlobalSku < ActiveRecord::Migration
  def change
  	add_column :global_skus, :fabric_id, :integer
  	add_column :global_skus, :fabric_name, :string
  end
end
