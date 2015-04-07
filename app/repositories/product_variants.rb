# usage
#   Repositories::ProductVariants.new(product_id: product_id).read_all
#     returns list of all available variants for product
#
#   Repositories::ProductVariants.new(product_id: product_id).read(variant_id)
#     returns specific variant
#
#   Repositories::ProductVariants.read(variant_id) 
#     return variant, regardless of activity or master etc
#     archive - required for user cart products
#
# ProductVariant {
#   id
#   size_id
#   color_id
#   quantity [ in stock ]
# }
#
class Products::ProductVariants < Array
  def serialize
    map{|variant| variant.marshal_dump}
  end
end

module Repositories; end
class Repositories::ProductVariants
  include Repositories::CachingSystem

  attr_reader :product_id

  def initialize(options = {})
    @product_id = options[:product_id]
    raise ArgumentError.new('no product_id given') if product_id.blank?
  end

  def read_all
    @product_variants ||= Products::ProductVariants.new(read_product_variants)
  end

  def read(variant_id)
    read_all.detect{|v| v.id  == variant_id }
  end

  def self.read(variant_id)
    Rails.cache.fetch("product-variant-#{ variant_id}",  Repositories::CachingSystem.cache_fetch_params) do
      variant = Spree::Variant.where(id: variant_id).first
      variant.blank? ? FastOpenStruct.new({}) : format_variant(variant)
    end
  end

  private

    def self.format_variant(variant)
      FastOpenStruct.new({
        id: variant.id,
        size_id: variant.option_values.find{|ov| ov.option_type_id == Spree::Variant.size_option_type.id }.try(:id),
        color_id: variant.option_values.find{|ov| ov.option_type_id == Spree::Variant.color_option_type.id }.try(:id),
        count_on_hand: variant.count_on_hand,
        fast_delivery: variant.fast_delivery,
        available: variant.available?
      })
    end

    def cache_key
      "available-product-variants-#{ product_id }"
    end

    def read_product_variants
      Spree::Variant.active.where(is_master: false, product_id: product_id).includes(:option_values).collect do |variant|
        self.class.format_variant(variant)
      end
    end

    cache_results :read_product_variants
end
