class GlobalSku < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :variant, class_name: 'Spree::Variant'

  alias_method :upc, :id

  attr_accessible :sku,
                  :style_number,
                  :product_name,
                  :size,
                  :color_id,
                  :color_name,
                  :fabric_name,
                  :fabric_id,
                  :customisation_id,
                  :customisation_name,
                  :height_value,
                  :data,
                  :product,
                  :product_id,
                  :variant,
                  :variant_id

  validates_uniqueness_of :sku

  serialize :data, JSON

  def self.find_or_create_by_line_item(line_item_presenter:)
    where(sku: line_item_presenter.sku).first || create_by_line_item(line_item_presenter: line_item_presenter)
  end

  def self.create_by_line_item(line_item_presenter:)
    customizations = Array.wrap(line_item_presenter.item.customizations)
    GlobalSku::Create.new(
      style_number:   line_item_presenter.style_number,
      product_name:   line_item_presenter.style_name,
      size:           line_item_presenter.size,
      color_name:     line_item_presenter.colour_name,
      fabric_name:    line_item_presenter.fabric_name,
      height:         line_item_presenter.height,
      customizations: customizations
    ).call
  end

  def self.find_or_create_by_spree_variant(variant:)
    where(sku: variant.sku).first || create_by_spree_variant(variant: variant)
  end

  def self.create_by_spree_variant(variant:)
    self.create!(
      sku: variant.sku,
      style_number: variant.product.master.sku,
      product_name: variant.product.name,
      size: variant.dress_size.try(:name),
      color_id: variant.dress_color.try(:id),
      color_name: variant.dress_color.try(:name),
      customisation_id: nil,
      customisation_name: nil,
      height_value: LineItemPersonalization::DEFAULT_HEIGHT,
      data: nil,
      product_id: variant.product_id,
      variant_id: variant.id
    )
  end
end
