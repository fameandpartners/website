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

  scope :fast_making, -> do
    joins(making_options: :product_making_option).
      where(product_making_options: { option_type: 'fast_making' })
  end

  scope :super_fast_making, -> do
    joins(making_options: :product_making_option).
      where(product_making_options: { option_type: 'super_fast_making' })
  end

  scope :slow_making, -> do
    joins(making_options: :product_making_option).
      where(product_making_options: { option_type: 'slow_making' })
  end

  scope :standard_making, -> do
    joins('LEFT JOIN line_item_making_options limo ON limo.line_item_id = spree_line_items.id').
      joins('LEFT JOIN product_making_options pmo ON limo.making_option_id = pmo.id').
      where('pmo.id IS NULL')
  end

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

    if fabric.present? && !recommended_fabric?
      total_price += fabric.price_in(self.currency)
    end

    total_price
  end

  # this method returns the total adjustment of all making_options adjustments
  def making_options_price_adjustment
    total_adjustment = 0

    making_options.each do |mo|
      if (mo.product_making_option&.fast_making? || mo.product_making_option&.super_fast_making? ) and mo.price
        total_adjustment += mo.price
      end
      # slow_making price will be percentage based
      if mo.product_making_option&.slow_making?
        total_adjustment = total_adjustment + self.attributes["price"]*mo.price
      end
    end

    total_adjustment
  end

  def fast_making?
    making_options.any? {|mo| mo.product_making_option&.fast_making? }
  end

  def super_fast_making?
    making_options.any? {|mo| mo.product_making_option.super_fast_making? }
  end

  def slow_making?
    making_options.any? {|mo| mo.product_making_option.slow_making? }
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

  def cart_item
    @cart_item ||= Repositories::CartItem.new(line_item: self).read
  end

  def image
    cart_item.image.present? ? Spree::Image.find(cart_item.image.id) : nil
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
    60.days.ago >= period_in_business_days(self.delivery_period).business_days.after(self.order.completed_at)
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
        "image": self.image_url
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
        "fabricCode": self&.fabric&.name
      }
    end
    if self.item_return.present?
      json['line_item']['returns_meta'] = {
        "created_at_iso_mdy": self.item_return.created_at.strftime("%m/%d/%y"),
        "return_item_state": self.item_return.acceptance_status,
        "item_return_id": self.item_return.id,
        "label_pdf_url": self.item_return&.item_return_label&.label_pdf_url || '',
        "label_image_url": self.item_return&.item_return_label&.label_image_url || '',
        "label_url": self.item_return&.item_return_label&.label_url || ''
      }
    end
    json
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

  def recommended_fabric?
      fp = FabricsProduct.where(fabric_id: self.fabric_id, product_id: self.product.id).first
      fp&.recommended
  end

  private

  def period_in_business_days(period)
      value = major_value_from_period(period)
      period_units(period) == 'weeks' ? value * 5 : value
  end

  # returns days/weeks from string
  def period_units(period)
    period.match(/(?<=\d\s)[\w\s]+$/).to_s
  end

  # returns the larger number from the range in given string
  def major_value_from_period(period)
    period.match(/\d+(?=\s+\w+|$)/).to_s.to_i
  end

  # returns small number
  def minor_value_from_period(period)
    period.match(/\d+/).to_s.to_i
  end

end
