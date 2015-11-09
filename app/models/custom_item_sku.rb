class CustomItemSku
  attr_reader :line_item

  def initialize(line_item)
    @line_item = line_item
  end

  def call
    return line_item.variant.sku unless line_item.personalization.present?
    "#{style_number}#{size}#{colour}#{custom}"
  end

  def style_number
    if line_item.variant.is_master?
      line_item.variant.sku
    else
      line_item.variant.product.master.sku
    end.to_s.upcase
  end

  def colour
    "C#{line_item.personalization.color.id}"
  end

  def size
    line_item.personalization.size.name.to_s.gsub('/', '')
  end

  def custom
    "X"
  end
end
