class AddMissingBodyShapesToProductStypeProfile < ActiveRecord::Migration
  def change
    add_column :product_style_profiles, :athletic, :integer, after: :pear
    add_column :product_style_profiles, :petite, :integer, after: :petite
  end
end
