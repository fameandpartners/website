class AddTitleToSpreeBannerBoxes < ActiveRecord::Migration
  def change
    add_column :spree_banner_boxes, :title, :text
  end
end
