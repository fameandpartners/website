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

  column :id, html: true do |image|
    link_to image.id, admin_ui.edit_customisation_render3d_image_path(image)
  end
  column :product, html: true  do |image|
    link_to image.product.name, spree.admin_product_path(image.product)
  end
  column :dress_color do |image|
    image.color_value.try(:name)
  end
  column :dress_customisation do |image|
    image.customisation_value.try(:name) || 'Default'
  end
  column :product_sku, label: 'Product SKU' do |image|
    image.product.sku
  end
  column :remove?, html: true do |image|
    button_to('Remove', admin_ui.customisation_render3d_image_path(image), action: 'destroy', method: 'delete', class: 'btn btn-danger', data: { confirm: 'Are you sure?' })
  end
end
