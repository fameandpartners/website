require 'datagrid'

class ProductColorValuesGrid
  include ::Datagrid

  scope do
    ProductColorValue
      .includes(:product => :master)
      .includes(:option_value)
      .order('product_color_values.product_id')
  end

  filter :product do |value|
    where(Spree::Product.arel_table[:name].matches("%#{value}%"))
  end
  filter :product_id

  filter :product_active, :xboolean, default: true do |value|
    if value
      where(product_id: Spree::Product.active)
    end
  end

  filter :style_number do |value|
    where(Spree::Variant.arel_table[:sku].matches("%#{value}%"))
  end

  filter :color do |value|
    where(Spree::OptionValue.arel_table[:presentation].matches("%#{value}%"))
  end

  filter :active, :xboolean
  filter :custom, :xboolean

  column :id do |pcv|
    format(pcv.id) do
      link_to(pcv.id, edit_product_color_path(pcv))
    end
  end

  column :product do |pcv|
    format(pcv.product.name) do
      link_to(pcv.product.name, spree.admin_product_path(pcv.product))
    end
  end

  column :product_active do |pcv|
    format(pcv.product.active?) do |active|
      class_name = active ? 'check-square-o' : 'square-o'
      content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
    end
  end

  column(:style_number) { |pcv| pcv.product.sku }
  column :color do |pcv|
    pcv.option_value.name
  end

  column :preview do |pcv|
    format(pcv.option_value.name) do |color_name|
      render 'admin_ui/product_colors/colour_preview', color_name: color_name
    end
  end

  column :active? do |pcv|
    format(pcv.active?) do |active|
      class_name = active ? 'check-square-o' : 'square-o'
      content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
    end
  end

  column :custom? do |pcv|
    format(pcv.custom?) do |custom|
      content_tag(:i, 'Custom', class: "fa fa-scissors fa-lg") if custom
    end
  end

  column :recommended? do |pcv|
    format(pcv.recommended?) do |recommended|
      class_name = recommended ? 'tag' : 'scissors'
      content_tag(:i, 'R', class: "fa fa-#{class_name}  fa-lg") if recommended
    end
  end

  column :images? do |pcv|
    format(pcv.images.any?) do |has_images|
      class_name = has_images ? 'image text-default' : 'warning text-warning'
      content_tag(:i, '', class: "fa fa-#{class_name}  fa-lg")
    end
  end

  column :remove? do |pcv|
    format(pcv.id) do
      button_to('Remove', product_color_path(pcv), action: 'destroy', method: 'delete', class: 'btn btn-danger', data: { confirm: 'Are you sure?' })
    end
  end
end
