class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string    :path, :null => false
      t.boolean   :filterable
      t.text      :taxon_ids, :null => false
      # t.text      :code, :null => false
      # t.text      :banner, :null => false
      # t.text      :content
      t.timestamps
    end

    add_index :landing_pages, :path, :unique => true    
  end
end
