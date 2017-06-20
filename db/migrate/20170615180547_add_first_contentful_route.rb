class AddFirstContentfulRoute < ActiveRecord::Migration
  def up
    cr = ContentfulRoute.new
    cr.route_name = '/the-anti-fast-fashion-shop'
    cr.controller = 'contentful'
    cr.action = 'main'
    cr.save
  end

  def down
    ContentfulRoute.destroy_all
  end
end
