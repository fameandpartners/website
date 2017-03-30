Spree::LineItem.class_eval do
  has_one :personalization,
          class_name: 'LineItemPersonalization'

  has_one :fabrication

  has_one :item_return, inverse_of: :line_item

  has_one :size_normalisation, inverse_of: :line_item, class_name: 'LineItemSizeNormalisation'

  has_many :making_options, foreign_key: :line_item_id, class_name: '::LineItemMakingOption', dependent: :destroy

  scope :fast_making, -> do
    joins(making_options: :product_making_option).
      where(product_making_options: { option_type: 'fast_making' })
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

  after_save do
    order.clean_cache!
  end

  after_destroy do
    order.clean_cache!
  end

  # Note: it seems we need to store this value in DB.
  def delivery_period
    delivery_period_policy.delivery_period
  end

  def delivery_period_policy
    @delivery_period_policy ||= Policies::LineItemDeliveryPolicy.new(self)
  end

  def price
    total_price = super

    if

    if personalization.present?
      total_price += personalization.price
    end

    total_price
  end

  # this method returns the total adjustment of all making_options adjustments
  def making_options_price_adjust
    total_adjustment = 0
    making_options.each do |mo|
      if mo.fast_making?
        total_adjustment += mo.price
      end
      if mo.slow_making?
        total_adjustment += total_adjustment*mo.price
      end
    end
    total_adjustment
  end

  def fast_making?
    making_options.any? {|option| option.product_making_option.fast_making? }
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
    if personalization.blank?
      variant.options_text
    else
      values = variant.options_hash.merge(personalization.options_hash)
      array = []

      values.each do |type, value|
        array << (value.present? ? "#{type}: #{value}" : type.to_s)
      end

      array.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
    end
  end

  def making_options_text
    return '' if making_options.blank?
    making_options.map{|option| option.name.upcase }.join(', ')
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
end
