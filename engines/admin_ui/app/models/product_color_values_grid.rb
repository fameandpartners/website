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

  filter :style_number do |value|
    where(Spree::Variant.arel_table[:sku].matches("%#{value}%"))
  end

  column :id
  column :product do |pcv|
    pcv.product.name
  end

  column(:style_number) { |pcv| pcv.product.sku }
  column :color do |pcv|
    pcv.option_value.name
  end

  column :preview do |pcv|
    format(pcv.option_value.name) do |color_name|
      content_tag(:div,
                  content_tag(:div, '&nbsp;'.html_safe, class:"color-#{color_name}"),
                  class: 'color-option')
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
end
