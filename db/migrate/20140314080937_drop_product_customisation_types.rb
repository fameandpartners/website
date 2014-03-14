class DropProductCustomisationTypes < ActiveRecord::Migration
  def up
    drop_table :product_customisation_types
  end

  def down
    create_table :product_customisation_types do |t|
      t.integer  :product_id
      t.integer  :customisation_type_id
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end
end
