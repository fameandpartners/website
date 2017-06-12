class CreateContentfulRoutes < ActiveRecord::Migration
  def change
    create_table :contentful_routes do |t|
      t.string :route_name
      t.string :controller
      t.string :action

      t.timestamps
    end
  end
end
