class LineItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper

  attributes :id,
    :color,
    :height_value,
    :height_unit,
    :name,
    :sku,
    :pid,
    :price,
    :strikethrough_price,
    :size,
    :url,
    :image

  has_many :making_options, serializer: MakingOptionSerializer
  has_one  :fabric, serializer: FabricSerializer
  has_one  :color, serializer: ColorSerializer
  has_one  :size, serializer: SizeSerializer
  has_many :customizations, serializer: CustomizationSerializer



  def name
    object.style_name
  end

  def sku
    object.product_sku
  end

  def pid
    object.new_sku
  end

  def strikethrough_price
    object.old_price ? object.old_price * 100 : nil
  end

  def price
    object.price * 100
  end

  def url
    'TODO'
  end

  def image
    'TODO'
  end

  def customizations
    JSON.parse(object.customizations)
  end

  def making_options
    object.making_options.map(&:product_making_option).map(&:making_option)
  end
end
