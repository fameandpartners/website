Spree::LineItem.class_eval do
  has_one :personalization,
          class_name: 'LineItemPersonalization'

  has_one :fabrication

  has_many :making_options, foreign_key: :line_item_id, class_name: '::LineItemMakingOption', dependent: :destroy

  after_save do
    order.clean_cache!
  end

  after_destroy do
    order.clean_cache!
  end

  def price
    total_price = super

    total_price += making_options_price

    if personalization.present?
      total_price += personalization.price
    end

    total_price
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
end
