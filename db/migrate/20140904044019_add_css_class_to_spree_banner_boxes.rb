class AddCssClassToSpreeBannerBoxes < ActiveRecord::Migration
  def change
    add_column :spree_banner_boxes, :css_class, :text
  end
end
