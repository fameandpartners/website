class CreateAndLinkThemes < ActiveRecord::Migration
  def up
  	create_table :themes do |t|
      t.string :name
      t.string :presentation
      t.column :color, :jsonb
      t.column :collection, :jsonb
    end

  end

  def down
  	drop_table :themes
  end
end
