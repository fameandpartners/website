class DropCustomisationTypes < ActiveRecord::Migration
  def up
    drop_table :customisation_types
  end

  def down
    create_table :customisation_types do |t|
      t.integer  :position
      t.string   :name
      t.string   :presentation
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end
end
