# TODO: 24th November 2016 - Watch `Orders::LineItemCSVPresenter#personalization_sku` method, since this generator logic duplicated.
class CustomItemSku
  attr_reader :line_item

  def initialize(line_item)
    @line_item = line_item
  end

  def call
    # return line_item.variant.sku unless line_item.personalization.present?
    if line_item.personalization&.sku.nil?
      csku = Skus::Generator.new(
        style_number:            style_number,
        size:                    size,
        color_id:                color_id,
        fabric_id:               fabric_id,
        fabric:                  line_item.fabric,
        height:                  height,
        customization_value_ids: customization_value_ids
      ).call

      if line_item.personalization
        line_item.personalization.sku = csku
        line_item.personalization.save!
      end
      csku
    else
      line_item.personalization.sku
    end
  end

  def style_number
    if line_item.variant.is_master?
      line_item.variant.sku
    else
      line_item.variant.product.master.sku
    end
  end

  def color_id
    line_item.personalization ? line_item.personalization.color.id : line_item.variant&.dress_color&.id
  end

  def size
    line_item.personalization ? line_item.personalization.size.name : line_item.variant&.dress_size&.name
  end

  def customization_value_ids
    line_item.customizations ? JSON.parse(line_item&.customizations)&.map{ |cust| cust['customisation_value']['id'] }&.sort : []
  end

  def height
    line_item.personalization ? line_item.personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
  end

  def fabric_id
    line_item.fabric ? line_item.fabric.id : ''
  end

end
