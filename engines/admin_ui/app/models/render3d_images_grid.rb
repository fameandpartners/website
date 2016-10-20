require 'datagrid'

class Render3dImagesGrid
  include Datagrid

  scope do
    Render3d::Image
      .includes(:product, :color_value, :customisation_value)
      .where(product_id: Spree::Product.active)
  end

  filter :product do |value|
    where("spree_products.name ilike ?", "%#{value}%")
  end
  filter(:dress_color, :enum, select: ->{ Spree::OptionType.color.option_values.map {|c| ["#{c.presentation} (#{c.name})", c.id] } }) do |value|
    where("spree_option_values.id = ?", value)
  end
  filter(:dress_customisation, :enum, select: ->{ CustomisationValue.all.map {|c| ["#{c.presentation} (#{c.name})", c.id] } }) do |value|
    where("customisation_value.id = ?", value)
  end

  column :id, html: true do |x|
    link_to x.id, admin_ui.render3d_image_path(x)
  end
  column :product, html: true  do |x|
    link_to x.product.name, spree.admin_product_path(x.product)
  end
  column :dress_color do |x|
    x.color_value.try(:name)
  end
  column :dress_customisation do |x|
    x.customisation_value.try(:name) || 'Default'
  end
  column :product_sku, label: 'Product SKU' do |x|
    x.product.sku
  end
  column :actions, html: true do |x|
    content_tag(:p, class: 'action-links') do
      concat link_to 'edit', admin_ui.edit_render3d_image_path(x), class: 'btn btn-xs btn-info'
      concat ' '
      concat link_to 'delete', admin_ui.render3d_image_path(x), class: 'btn btn-xs btn-info'
    end
  end
end
