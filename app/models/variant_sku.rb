class VariantSku
  attr_reader :variant

  def initialize(variant)
    @variant = variant
  end

  # Note that this is somewhat duplicated with CustomItemSku
  def call
    return variant.sku.to_s.upcase if variant.is_master
    "#{style_number}#{size}#{color}#{custom}"
  rescue StandardError => e
    Raven.capture_exception(e)
    NewRelic::Agent.notice_error(e, variant_id: variant.id)
    variant.sku.to_s.upcase
  end

  def style_number
    variant.product.master.sku.to_s.upcase
  end

  def size
    if variant.dress_size
      variant.dress_size.name.to_s.gsub('/', '')
    end
  end

  def color
    if variant.dress_color
      "C#{variant.dress_color.id}"
    end
  end

  def custom
    ''
  end
end
