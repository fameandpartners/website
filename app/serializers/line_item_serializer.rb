class LineItemSerializer < ActiveModel::Serializer
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper
  include Spree::ProductsHelper
  include PathBuildersHelper

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
    :image_url,
    :projected_delivery_date,
    :return_eligible,

    #for legacy checkout
    :display_price

  has_many :making_options, serializer: MakingOptionSerializer
  has_many :available_making_options, serializer: MakingOptionSerializer
  has_one  :fabric, serializer: FabricsProductSerializer
  has_one  :color, serializer: ColorSerializer
  has_one  :size, serializer: SizeSerializer
  has_one  :shipment,  serializer: ShipmentSerializer
  has_one  :fabrication, serializer: FabricationSerializer
  has_many :customizations, serializer: CustomizationSerializer
  has_one :return, serializer: ItemReturnSerializer

  def initialize(object, options={})
    super(object, options.merge(scope: options[:scope].merge(currency: object.currency )))
  end


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

  def display_price
    '$' + object.price.to_s
  end

  def url
    collection_product_path(object)
  end

  def image_url
    object.image_url
  end

  def return_eligible
    object.return_eligible?(scope[:current_user])
  end

  def customizations
    object.customizations
  end

  def making_options
    object.making_options.map(&:product_making_option).compact.map(&:making_option).compact
  end

  def available_making_options
    object.order.completed? ? [] : object.product.making_options.map(&:making_option)
  end
  
  def return
    object&.item_return
  end

  def fabric
    object.fabrics_product
  end
end
