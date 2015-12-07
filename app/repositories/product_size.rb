# usage:
#   standalone:
#     Repositories::ProductSize.read(size_id)
#     Repositories::ProductSize.read_all
#
#   for product
#     Repositories::ProductSize.new(site_version: site_version, product: product).read(id)
#     Repositories::ProductSize.new(site_version: site_version, product: product).read_all
#
# - site version : we have different measure systems in us/au/uk
# - product      : price for extra sizes depends from dress
# - product_variants : not all sizes in system available for dress
#
# shortly:
#   au: [4 <- free sizes -> 16, 18 <- extra price -> 26 ]
#   us: [0 <- free sizes -> 12, 14 <- extra price -> 22 ]
#   plus size+ dresses have free prices for extra size
#
module Repositories; end
class Repositories::ProductSize
  attr_reader :site_version, :product, :product_variants

  def initialize(options = {})
    @site_version     = options[:site_version] || SiteVersion.default
    @product          = options[:product]
    @product_variants = options[:product_variants]
    @product_variants ||= Repositories::ProductVariants.new(product_id: product.id).read_all
  end

  def product_sizes_ids
    @product_sizes_ids ||= product_variants.map{|variant| variant.size_id}.compact.uniq
  end

  def read_all
    product_sizes_ids.map{|size_id| read(size_id) }.compact.sort_by{|size| size.sort_key }
  end

  def read(size_id)
    size = Repositories::ProductSize.read(size_id)

    # Possibly remove this and swap on the presentation in UI layer.
    # Shim for existing mutated behaviour
    size.presentation = size.send("presentation_#{site_version.code.downcase}")

    size
  end

  EXTRA_SIZES = %w[
          US14/AU18
          US16/AU20
          US18/AU22
          US20/AU24
          US22/AU26
          US24/AU28
          US26/AU30
        ].freeze
  private def extra_sizes
    EXTRA_SIZES
  end

    def self.sizes_map
      @sizes_map ||= fetch_sizes_map
    end

    def self.fetch_sizes_map
      result = {}
      Array.wrap(Spree::OptionType.size.try(:option_values)).each do |option_value|
        # TODO - Remove value
        value = option_value.name

        size_us, size_au = option_value.presentation.split('/')

        result[option_value.id] = OpenStruct.new(
          id:              option_value.id,
          name:            option_value.name,
          presentation:    option_value.presentation,
          presentation_au: size_au,
          presentation_us: size_us,
          value:           value,
          sort_key:        size_us.tr('US', '').to_i,
          extra_price:     nil,
        )
      end
      result
    end

    def self.read_all
      sizes_map.values
    end

    def self.read(size_id)
      size = sizes_map.fetch(size_id) { raise ArgumentError.new("Unknown_size_id #{size_id}") }
      size.clone
    end
end
