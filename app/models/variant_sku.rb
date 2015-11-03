class VariantSku
  attr_reader :variant

  def initialize(variant)
    @variant = variant
  end

  def call
    variant.generate_sku
  end
end
