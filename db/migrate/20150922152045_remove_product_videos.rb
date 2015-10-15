class RemoveProductVideos < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.table_exists? :product_videos
      drop_table :product_videos
    end

    property = Spree::Property.find_by_name('video_id')
    if property
      Spree::ProductProperty.where(property_id: property).delete_all
    end
  end

  def down
  end
end
