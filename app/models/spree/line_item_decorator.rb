Spree::LineItem.class_eval do
  has_one :personalization,
          class_name: 'LineItemPersonalization'

  def price
    if personalization.present?
      super + personalization.price
    else
      super
    end
  end

  def in_sale?
    old_price.present?
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
        array << "#{type}: #{value}"
      end

      array.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
    end
  end

  def image
    @image ||= begin
      result = product.images_for_variant(variant).first
      if result.nil? && !variant.is_master?
        result = product.images_for_variant(product.master).first
      end
      result ||= product.images.first
    end
  end
end
