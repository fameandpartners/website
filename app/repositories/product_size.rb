# returns ProductSize
# usage:
#   standalone:
#     Repositories::ProductSize.read_all
#     Repositories::ProductSize.read(size_id)
#
#   for product
#     Repositories::ProductSize.new(product: product).read(id)
#     Repositories::ProductSize.new(product: product).read_all
#
# result: 
#   OptionValues::ProductSizePresenter
#
module Repositories; end
class Repositories::ProductSize
  attr_reader :product, :product_variants

  def initialize(options = {})
    @product          = options[:product]
    @product_variants = options[:product_variants]
    @product_variants ||= Repositories::ProductVariants.new(product_id: product.id).read_all
  end

  def product_sizes_ids
    @product_sizes_ids ||= product_variants.map{|variant| variant.size_id}.uniq
  end

  def read_all
    product_sizes_ids.map{|size_id| read(size_id) }.compact.sort_by{|size| size.value.to_i }
  end

  def read(size_id)
    size = Repositories::ProductSize.read(size_id)
    size.allowed_size? ? size : nil
  end

  class << self
    def sizes_map
      @sizes_map ||= begin
        result = {}
        Spree::OptionValue::ProductSize.all.each do |size|
          result[size.id] = size
        end
        result
      end
    end

    def read_all
      sizes_map.values
    end

    def read(size_id)
      sizes_map[size_id].clone
    end
  end
end
