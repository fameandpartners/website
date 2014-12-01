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
    @collection   = options[:collection]
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
      @search_results ||= build_search_query.results
    end

    def taxon_ids
      [collection.try(:id)].compact | Array(@taxon_ids)
    end

    def locale
      I18n.locale.to_s.downcase.underscore.to_sym
    end

    def currency
      site_version.currency.downcase
    end

    def build_product(search_result)
      item = search_result
      OpenStruct.new(
        id: item.product.id,
        master_id: item.product.master_id,
        #variant_id: item.id,
        name: item.product.name,
        permalink: item.product.permalink,
        'can_be_customized?'.to_sym => item.product.can_be_customized,
        fast_delivery: item.product.fast_delivery,
        image_url: product_image(item.images),
        price: product_price(item.product, item.prices),
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

    def product_image(images = [])
      images.map{|i| i.try(:large) }.compact.first || 'noimage/product.png'
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

    def build_search_query
      # to make them visible inside Tire.search block
      taxons = taxon_ids
      products = products_ids
      body_shapes = @body_shapes

      Tire.search(:color_variants, size: 1000) do
        filter :bool, :must => { :term => { 'product.is_deleted' => false, 'product.is_hidden' => false } } 
        filter :exists, :field => :available_on
        filter :bool, :should => { :range => { 'product.available_on' => { :lte => Time.now } } }

        # Filter by availability of customisation colour
        filter :bool, :must => { :term => { 'product.color_customizable' => true } }

        # Filter by taxons
        filter(:terms, 'product.taxon_ids' => taxons) if taxons.present?

        # exclude already found [ somethere else ]
        if products.present?
          filter :bool, :must => {
            :not => {
              :terms => {
                :id => products
              }
            }
          }
        end

        if body_shapes.present?
          if body_shapes.size.eql?(1)
            filter :bool, :should => {
                          :range => {
                            "product.#{body_shapes.first}" => {
                              :gte => 4
                            }
                          }
                        }
          else
            filter :or,
                   *body_shapes.map do |body_shape|
                     {
                       :bool => {
                         :should => {
                           :range => {
                             "product.#{body_shape}" => {
                               :gte => 4
                             }
                           }
                         }
                       }
                     }
                   end
          end
        end

        # only available items
        filter :bool, :must => { :term => { 'product.in_stock' => true } }

        sort do
          by 'product.position', 'asc'
        end
      end
    end
end
