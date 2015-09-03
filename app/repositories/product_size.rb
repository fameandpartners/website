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
#   also, size value should be even
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
    @product_sizes_ids ||= product_variants.map{|variant| variant.size_id}.uniq
  end

  def read_all
    product_sizes_ids.map{|size_id| read(size_id) }.compact.sort_by{|size| size.value.to_i }
  end

  def read(size_id)
    size = Repositories::ProductSize.read(size_id)
    return nil if !valid_for_site_version?(size)

    if size_have_extra_price?(size)
      size.extra_price  = true
    end

    size.presentation = "#{ site_version.size_settings.locale_code.upcase } #{ size.presentation }"

    size
  end

  private

    def size_have_extra_price?(size)
      return nil if product_has_free_extra_sizes?
      size.value >= extra_size_start
    end

    # size should have even value between 0..22 or 4...26
    def valid_for_site_version?(size)
      size.present? && size.value.even? && size.value >= site_version.size_settings.size_start && size.value <= site_version.size_settings.size_end
    end

    def product_has_free_extra_sizes?
      return @product_has_free_extra_sizes if instance_variable_defined?('@product_has_free_extra_sizes')

      @product_has_free_extra_sizes = begin
        taxon = Repositories::Taxonomy.get_taxon_by_name('Plus Size')
        Spree::Classification.where(product_id: product.id, taxon_id: taxon.id ).exists?
      end
    end

    def extra_size_start
      site_version.size_settings.size_charge_start rescue 18
    end

    def default_size_start
      site_version.size_settings.size_start rescue 4
    end

    def default_size_end
      site_version.size_settings.size_end rescue 26
    end

  class << self
    def sizes_map
      @sizes_map ||= begin
        result = {}
        Array.wrap(Spree::Variant.size_option_type.try(:option_values)).each do |option_value|
          value = Integer(option_value.name) rescue option_value.name

          result[option_value.id] = OpenStruct.new(
            id: option_value.id,
            name: option_value.name,
            presentation: option_value.presentation,
            value: value.to_i
          )
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

    def size_attributes
      SIZE_ATTRIBUTES
    end

    def attributes_by_us_name(us_name)
      size_attributes.detect do |attributes|
        attributes[:name][:us].eql?(us_name.to_s)
      end
    end

    def attributes_by_au_name(au_name)
      size_attributes.detect do |attributes|
        attributes[:name][:au].eql?(au_name.to_s)
      end
    end
  end
end
