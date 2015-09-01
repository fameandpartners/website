# just simpler presenter
# don't want to use open structs)
#   OptionValues::ProductSizePresenter.new(option_value: option_value, product: product, site_version: site_version)
module OptionValues
  class ProductSizePresenter
    attr_reader :id, :name, :presentation, :extra_price, :extra_size

    def initialize(option_value:, product:, site_version:)
      @id           = option_value.id
      @name         = option_value.name
      @value        = option_value.value
      @presentation = option_value.presentation_for(site_version: site_version)
      @extra_size   = option_value.extra_size?
      @extra_price  = option_value.extra_size? && !product.has_free_extra_sizes?
    end

    alias_method :extra_size?, :extra_size
    alias_method :extra_price?, :extra_price

    def default_price
      !extra_price?
    end
    alias_method :default_price?, :default_price

    def serialize
      {
        id: id,
        name: name,
        presentation: presentation,
        extra_price: extra_price
      }
    end
  end
end
