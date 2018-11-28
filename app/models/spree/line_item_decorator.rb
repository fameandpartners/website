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
    super ||
    CustomisationValue.where(id: self.personalization&.customization_value_ids || []).to_json
  end

  def delivery_period_policy
    @delivery_period_policy ||= Policies::LineItemDeliveryPolicy.new(self)
  end

  def price
    total_price = super

    if making_options.exists?
      total_price += making_options_price_adjustment
    end

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
  
  def making_options_price
    making_options.sum(&:price)
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
    making_options.map{|option| option.name&.upcase }.reject { |x| x==nil }.join(', ')
  end

  def factory
    Factory.for_product(product)
  end

  def promotional_gift?
    product.try(:name) == "Gift"
  end

  def color_name
    cart_item.try(:color).try(:presentation) || ''
  end

  def color_code
    cart_item.try(:color).try(:name) || ''
  end

	def color_hex
		cart_item&.try(:color)&.try(:value)&.include?("#") ? cart_item.try(:color).try(:value) : nil
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
    cart_item.try(:image).try(:large) || ''
  end

  def size_name
    cart_item.try(:size).try(:presentation) || ''
  end

  def style_name
    curation_name || variant.try(:product).try(:name) || 'Missing Variant'
  end

  def fabric_swatch?
    self.product&.category&.category == 'Sample'
  end

  def return_insurance?
    product.name.downcase.include? "return_insurance"
  end

  def store_credit_only_return?
    !(personalization&.customization_values&.empty? && product.taxons.none? { |t| t.name == 'Bridal' }) && return_eligible_AC?
  end

  def return_eligible_AC?
    self.order.return_type.blank? || self.order.return_type == 'C'|| (self.order.return_type == 'A' && !self.order.promotions.any? {|x| x.code.downcase.include? "deliverydisc"}) #blank? handles older orders so we dont need to back fill
  end

  def return_eligible_B?
    self.order.return_type == 'B' && self.order.line_items.any?(&:return_insurance?)
  end

  def window_closed?
    delivery_date = self.delivery_period_policy.delivery_date

    !delivery_date || 60.days.ago >= delivery_date
  end

  def in_batch?
    !self.batch_collections.empty?
  end

  def as_json(options = { })
    json = super(options)
    json['line_item']['store_credit_only'] = self.store_credit_only_return?
    json['line_item']['window_closed'] = self.window_closed?
    if self.fabric_swatch?
      json['line_item']['products_meta'] = {
        "name": self.style_name,
        "price": self.price,
        "color": self.color_name,
        "image": self.image_url,
        "colorHex": self.color_hex,
      }
    else
      json['line_item']['products_meta'] = {
        "name": self.style_name,
        "price": self.price,
        "size": self.size_name,
        "color": self.color_name,
        "fabric": self&.fabric&.presentation,
        "height": self.height_name,
        "height_unit": self.height_unit,
        "height_value": self.height_value,
        "image": self.image_url,
        "sku": self.new_sku,
        "productSku": self.product_sku,
        "colorCode": self.color_code,
				"colorHex": self.color_hex,
        "fabricCode": self&.fabric&.name,
      }
      json['line_item']['fabrication'] = self&.fabrication
    end
    if self.item_return.present?
      json['line_item']['returns_meta'] = {
        "created_at_iso_mdy": self.item_return.created_at.strftime("%m/%d/%y"),
        "return_item_state": self.item_return.acceptance_status,
        "item_return_id": self.item_return.id,
        "label_pdf_url": self.item_return&.item_return_label&.label_pdf_url || '',
        "label_image_url": self.item_return&.item_return_label&.label_image_url || '',
        "label_url": self.item_return&.item_return_label&.label_url || '',
				"item_return": self.item_return
      }
    end
    json
  end

  def image(cropped: )
    images(cropped: cropped).first
  end
  def images(cropped: )
    product.images_for_customisation(self.personalization&.color&.name, self.fabric&.name, [], cropped)
  end

  def new_sku
    Spree::Product.format_new_pid(
      self.product_sku,
      self.fabric&.name || self.personalization&.color&.name|| self.color,
      JSON.parse(self.customizations)
    )
  end

  def product_sku
    self.variant.product.sku
  end
end
