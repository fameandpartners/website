class CreateContentfulRoutes < ActiveRecord::Migration
  def change
    create_table :contentful_routes do |t|
      t.string     :route_name,
      t.timestamps
    end
  end
end
