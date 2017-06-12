class AddFirstContentfulVersion < ActiveRecord::Migration
  def up
  	cful = ContentfulVersion.new
  	cful.change_message = "First version is the deepest."
  	cful.is_live = true
  	cful.payload = Contentful::Service.get_all_contentful_containers
  	cful.save!
  end

  def down
  	ContentfulVersion.destroy_all
  end
end
