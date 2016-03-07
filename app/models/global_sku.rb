class GlobalSku < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant

  attr_accessible :sku,
                  :style_number,
                  :product_name,
                  :size,
                  :color_id,
                  :color_name,
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
    where(sku: line_item_presenter.sku).first.presence || create_by_line_item(line_item_presenter: line_item_presenter)
  end

  def self.create_by_line_item(line_item_presenter:)
    self.create!(
      :sku                => line_item_presenter.sku,
      :style_number       => line_item_presenter.style_number,
      :product_name       => line_item_presenter.style_name,
      :size               => line_item_presenter.size,
      :color_id           => line_item_presenter.colour_id,
      :color_name         => line_item_presenter.colour_name,
      :height_value       => line_item_presenter.height,
      :product_id         => line_item_presenter.product_id,
      :variant_id         => line_item_presenter.variant_id
    )
  end
end
