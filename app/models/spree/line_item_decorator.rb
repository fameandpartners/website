Spree::LineItem.class_eval do
  has_one :personalization,
          class_name: 'LineItemPersonalization'

  has_one :fabrication
  has_one :line_item_update, class_name: 'Admin::LineItemUpdate'

  belongs_to :fabric

  has_one :item_return, inverse_of: :line_item
  belongs_to :return_inventory_item

  has_one :size_normalisation, inverse_of: :line_item, class_name: 'LineItemSizeNormalisation'

  has_many :making_options, foreign_key: :line_item_id, class_name: '::LineItemMakingOption', dependent: :destroy

  has_many :batch_collection_line_items
  has_many :batch_collections, :through => :batch_collection_line_items

  has_one :return_item, :class_name => 'ReturnRequestItem'


  # Note: it seems we need to store this value in DB.
  def delivery_period
    if self.delivery_date.nil? && self.order.state != 'complete'
      self.delivery_date = delivery_period_policy.delivery_period
      self.save!
      return self.delivery_date
    elsif self.delivery_date && (self.order.state == 'complete' || self.order.state == 'resumed')
      return self.delivery_date
    else
      return delivery_period_policy.delivery_period
    end
  end

  def customizations
    super ? JSON.parse(super) : []
  end

  def delivery_period_policy
    @delivery_period_policy ||= Policies::LineItemDeliveryPolicy.new(self)
  end

  def price
    total_price = super

    total_price += making_options_price_adjustment

    if personalization.present? && self.stock.nil?
      total_price += personalization.price
    end

    if fabric.present?
      fp = FabricsProduct.find_by_fabric_id_and_product_id(self.fabric_id, self.product.id)
      total_price += fp.price_in(self.currency)
    end

    total_price
  end

  # this method returns the total adjustment of all making_options adjustments
  def making_options_price_adjustment
    total_adjustment = 0

    making_options.each do |mo|
      total_adjustment += mo.flat_price if mo.flat_price
      total_adjustment += self.attributes["price"]*mo.percent_price if mo.percent_price
    end

    total_adjustment
  end

  def in_sale?
    old_price.present? && price != old_price
  end

  def amount_without_discount
    old_price * quantity
  end

  def money_without_discount
    Spree::Money.new(amount_without_discount, { :currency => currency })
  end

  def options_text
    if fabric_swatch?
      return "Fabric and Color: #{fabric.presentation}"
    end
    if personalization.blank?
      variant.options_text
    else
      values = variant.options_hash.merge(personalization.options_hash)
      array = []

      values.each do |type, value|
        if type == 'Color' && self.fabric
          array << "Fabric and Color: #{fabric.presentation}"
        else
          array << (value.present? ? "#{type}: #{value}" : type.to_s)
        end
      end

      array.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
    end
  end

  def making_options_text
    return '' if making_options.blank?
    making_options.map{|option| option.product_making_option.making_option.name }.join(', ')
  end

  def factory
    Factory.for_product(product)
  end

  def color
    personalization.try(:color)
  end

  def color_name
    color.try(:presentation) || ''
  end

  def color_code
    color.try(:name) || ''
  end

  def height_name
    personalization.try(:height) || ''
  end

  def height_unit
    personalization.try(:height_unit) || ''
  end

  def height_value
    personalization.try(:height_value) || ''
  end

  def image_url
    image(cropped: true)&.attachment&.url(:large)
  end

  def size
    personalization&.size
  end

  def size_name
    size&.presentation
  end

  def style_name
    curation_name || variant.try(:product).try(:name) || 'Missing Variant'
  end

  def fabric_swatch?
    self.product&.category&.category == 'Sample'
  end

  def fabrics_product
    fabric ? product.fabric_products.where(fabric_id: fabric.id).first : nil
  end

  def sample_sale?
    !self.stock.nil?
  end

  def return_insurance?
    product.name.downcase.include? "return_insurance"
  end

  def is_returnable_item?
    !fabric_swatch? && !return_insurance? && !sample_sale?
  end

  def is_returnable_order?
    return false unless order.completed?

    order.completed_at > DateTime.new(2018,11,20)  || order.line_items.any?(&:return_insurance?)
  end

  def return_window_open?
    return false unless order.completed?
    
    max_delivery_date = order.line_items.map(&:delivery_period_policy).map(&:delivery_date).compact.max

    60.days.ago <= max_delivery_date
  end

  def return_eligible?(current_user = nil)
    return false unless order.completed?
    return true if current_user&.admin?

    is_returnable_item? && is_returnable_order? && return_window_open? 
  end


  def window_closed?
    delivery_date = self.delivery_period_policy.delivery_date

    !delivery_date || 60.days.ago >= delivery_date
  end

  def in_batch?
    !self.batch_collections.empty?
  end
  
  def image(cropped: )
    images(cropped: cropped).first
  end

  def images(cropped: )
    product.images_for_customisation(self.personalization&.color&.name, self.fabric&.name, customizations, cropped)
  end

  def is_curation?
    product.curations.exists?(pid: new_sku)
  end

  def new_sku
    Spree::Product.format_new_pid(
      self.product_sku,
      self.fabric&.name || self.personalization&.color&.name|| self.color,
      customizations
    )
  end

  def product_sku
    self.variant.product.sku
  end

  def product_sku_with_fabric_code
    if fabric && fabric.production_code
      "#{self.variant.product.sku}~#{fabric.production_code}"
    else
      self.variant.product.sku
    end
  end

  def projected_delivery_date
    return unless order.completed?
    delivery_period_policy.delivery_date
  end

  def ship_by_date
    return unless order.completed?
    delivery_period_policy.ship_by_date
  end

  def shipment
    order.shipments.detect { |ship| ship.line_items.include?(self) }
  end

  def ignore_line?
    fabric_swatch? || return_insurance?
  end

  def production_sheet_url
    if Spree::Product.is_new_product?(product_sku)
      "#{configatron.product_catalog_url}/admin/productionsheet/#{new_sku}"
    end
  end
end
