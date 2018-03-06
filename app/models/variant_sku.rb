class VariantSku
  attr_reader :variant
  require 'pry-byebug'

  def initialize(variant)
    @variant = variant
  end

  def call
    return variant.sku.to_s.upcase if variant&.is_master
    Skus::Generator.new(
      style_number: style_number,
      size:         size,
      color_id:     color_id
    ).call
  rescue StandardError => e
    Raven.capture_exception(e)
    NewRelic::Agent.notice_error(e, variant_id: variant.id)

    variant.sku.to_s.upcase
  end

  def style_number
    variant.product.master.sku
  end

  def size
    variant.dress_size&.name
  end

  def color_id
    variant.dress_color&.id
  end
end
