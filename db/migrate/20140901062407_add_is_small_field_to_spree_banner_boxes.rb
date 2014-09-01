class AddIsSmallFieldToSpreeBannerBoxes < ActiveRecord::Migration
  def change
    add_column :spree_banner_boxes, :is_small, :boolean
  end
end
