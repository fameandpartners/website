class CreateProductVideos < ActiveRecord::Migration
  def up
    create_table :product_videos, force: true do |t|
      t.references :spree_product
      t.references :spree_option_value
      t.boolean :is_master, default: false
      t.string :color

      t.string :url, limit: 512
      t.string :video_id
      t.integer :position

      t.timestamps
    end

    load_product_video_from_property
  end

  def down
    drop_table :product_videos
  end

  private

  def load_product_video_from_property
    Spree::Product.all.each do |product|
      video_id = product.property('video_id')
      if video_id.present?
        video = product.videos.first_or_initialize(
          is_master: true,
          video_id: video_id
        )
        video.url = product.video_url
        video.save
      end
    end
  end
end
