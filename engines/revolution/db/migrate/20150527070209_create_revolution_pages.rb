class CreateRevolutionPages < ActiveRecord::Migration
  def change
    create_table :revolution_pages do |t|
      t.integer :template_id, :nil => false
      t.text    :path, :nil => false
      t.text    :canonical, :nil => true
      t.text    :redirect, :nil => true
      t.boolean :published, :default => true, :nil => false

      # acts as nested set
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0

      t.timestamps
    end

    add_index :revolution_pages, :path, :unique => true
    add_index :revolution_pages, :parent_id
    add_index :revolution_pages, :rgt
    add_index :revolution_pages, :published

  end
end
