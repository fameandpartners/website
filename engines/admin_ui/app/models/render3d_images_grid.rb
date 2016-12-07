require 'datagrid'

class Render3dImagesGrid
  include Datagrid

  scope do
    Render3d::Image
      .joins(:product, :color_value, :customisation_value)
      .joins("INNER JOIN spree_variants ON spree_products.id = spree_variants.product_id AND spree_variants.is_master = 't'")
      .where(product_id: Spree::Product.active)
  end

  filter :product do |value|
    where('LOWER(spree_products.name) LIKE :term OR LOWER(spree_variants.sku) LIKE :term', term: "%#{value}%")
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
  column :preview, html: true do |image|
    image_tag image.attachment.url
  end
  column :remove?, html: true do |image|
    button_to('Remove', admin_ui.customisation_render3d_image_path(image), action: 'destroy', method: 'delete', class: 'btn btn-danger', data: { confirm: 'Are you sure?' })
  end
end
