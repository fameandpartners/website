Spree::LineItem.class_eval do
  has_one :personalization,
          class_name: 'LineItemPersonalization'

  has_one :fabrication

  after_save do
    order.clean_cache!
  end

  after_destroy do
    order.clean_cache!
  end

  def price
    if personalization.present?
      super + personalization.price
    else
      super
    end
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

  def cart_item
    @cart_item ||= Repositories::CartItem.new(line_item: self).read
  end

  def image
    cart_item.image.present? ? Spree::Image.find(cart_item.image.id) : nil
  end

  def factory
    Factory.for_product(product)
  end
end
