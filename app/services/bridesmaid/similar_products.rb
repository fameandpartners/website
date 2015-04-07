# class, designed to extract additional products for bridesmaid-party/dresss only
# supposed to be wrapping over products extractor/finder/repository
# implement it later
#
# In the second section of the page display dresses from the bridesmaid taxon 
# that are also available in the colours the user selected.
class Bridesmaid::SimilarProducts
  attr_reader :site_version, :collection, :products_ids

  def initialize(options = {})
    @site_version = options[:site_version]
    @collection   = Array.wrap(options[:collection])
    @taxon_ids    = options[:taxon_ids]
    @body_shapes  = options[:body_shapes]
    @products_ids = options[:except]
  end

  def read_all
    #search_results.map do |item|
    #  build_product(item)
    #end
    unique_products = search_results.group_by{|item| item.product.id }
    unique_products.map do |product_id, items|
      build_product(items.first)
    end
  end

  private

    def search_results
      @search_results ||= begin
        Search::ColorVariantsQuery.build(
          taxon_ids: @taxon_ids,
          body_shapes: @body_shapes,
          exclude_products: products_ids
        ).results
      end
    end

    def taxon_ids
      [collection.map(&:id).compact, Array(@taxon_ids)]
    end

    def locale
      I18n.locale.to_s.downcase.underscore.to_sym
    end

    def currency
      site_version.currency.downcase
    end

    def build_product(search_result)
      item = search_result
      FastOpenStruct.new(
        id: item.product.id,
        master_id: item.product.master_id,
        #variant_id: item.id,
        name: item.product.name,
        permalink: item.product.permalink,
        'can_be_customized?'.to_sym => item.product.can_be_customized,
        fast_delivery: item.product.fast_delivery,
        image_url: product_image(item.images),
        image_urls: product_images(item.images),
        price: product_price(item.product, item.prices),
        discount: product_discount(item.product),
        path: product_path(item.product, item.color)
      )
    end

    def prices
      @prices ||= begin
        prices_ids = search_results.map do |item|
          item.prices[currency].present? ? item.prices[currency] : nil
        end.compact
        {}.tap do |result|
          Spree::Price.where(id: prices_ids).each do |price|
            result[price.id] = price
          end
        end
      end
    end

    def product_price(product, product_prices)
      price_id = product_prices[currency] || product_prices.to_hash.values.compact.first
      prices[price_id] || Spree::Price.new(amount: product.price, currency: currency)
    end

    def product_discount(product)
      Repositories::Discount.get_product_discount(product.id)
    end

    def product_image(images = [])
      product_images(images).first
    end

    def product_images(images = [])
      images.map{|i| i.try(:large) }.compact.presence || ['noimage/product.png']
    end

    # smt like this.
    # /au/dresses/dress-mirrored-sea-360/black
    def product_path(product, color)
      path_parts = [site_version.permalink, 'dresses']

      if product.urls[locale].present?
        path_parts.push( 
          ['dress', product.urls[locale]].reject(&:blank?).join('-')
         )
      else
        path_parts.push(
          ['dress', product.name, product.id].reject(&:blank?).join('-')
        )
      end

      if color.name
        path_parts.push( color.name )
      end

      "/" + path_parts.join('/')
    end
end
