class AddFirstContentfulVersion < ActiveRecord::Migration
  def up
    fark = nil
    File.open("db/contentful_dump.txt") {|f| fark = JSON.parse(f.read) }
    cful = ContentfulVersion.new
  	cful.change_message = "First version is the deepest."
  	cful.is_live = true
  	cful.payload = fark
  	cful.save!
  end

  def down
  	ContentfulVersion.destroy_all
  end
end
