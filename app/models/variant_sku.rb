class VariantSku
  attr_reader :variant

  def initialize(variant)
    @variant = variant
  end

  def call
    return variant.sku.to_s.upcase if variant.is_master

    parts = []
    parts << variant.product.master.sku.to_s.upcase

    if variant.dress_size
      parts << variant.dress_size.name.to_s.gsub('/', '')
    end

    if variant.dress_color
      parts << "C#{variant.dress_color.id}"
    end

    parts.join('')
  rescue
    variant.sku.to_s.upcase
  end
end
