class ConvertCustomizationColumnsToArray < ActiveRecord::Migration
  def up
    add_column :layer_cads, :customizations_enabled_for, :string, array:true, default: []
    remove_column :layer_cads, :customization_1
    remove_column :layer_cads, :customization_2
    remove_column :layer_cads, :customization_3
    remove_column :layer_cads, :customization_4
    
  end

  def down
    remove_column :layer_cads, :customizations_enabled_for
    add_column  :layer_cads, :customization_1, :string
    add_column  :layer_cads, :customization_2, :string
    add_column  :layer_cads, :customization_3, :string
    add_column  :layer_cads, :customization_4, :string
  end
end
