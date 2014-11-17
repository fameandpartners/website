# class, designed to extract products for bridesmaid-party/dresss only
# supposed to be wrapping over products extractor/finder/repository
# implement it later
class Bridesmaid::Products
  attr_reader :profile, :collection, :site_version

  def initialize(site_version, bridesmaid_profile, collection)
    @profile      = bridesmaid_profile
    @collection   = collection
    @site_version = site_version
  end

  def read_all
    unique_products = search.results.group_by{|item| item.product_id }
    unique_products.map do |product_id, items|
      build_product(items.first) # they ordered by colors match, so first record - most closest
    end
  end

  def in_development_mode?
    true
  end

  private
    def search_results
      @search_result ||= search.results
    end

    def color_ids
      [profile.color_id]
    end

    def taxon_ids
      [collection.id]
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
        variant_id: item.id,
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

      path_parts.push( color.try(:name) || profile.color.name )

      "/" + path_parts.join('/')
    end

    def search
      # to make them visible inside Tire.search block
      colors = color_ids
      taxons = taxon_ids

      if in_development_mode?
        colors = []
        taxons = []
      end

      Tire.search(:color_variants, size: 1000) do
        filter :bool, :must => { :term => { 'product.is_deleted' => false, 'product.is_hidden' => false } } 
        filter :exists, :field => :available_on
        filter :bool, :should => { :range => { 'product.available_on' => { :lte => Time.now } } }

        # Filter by colors
        filter(:terms, 'color.id' => colors) if colors.present?

        # Filter by taxons
        filter(:terms, 'product.taxon_ids' => taxons) if taxons.present?

        # only available items
        filter :bool, :must => { :term => { 'product.in_stock' => true } }

        sort do
          if colors.present?
            by ({
              :_script => {
                script: %q{
                  for ( int i = 0; i < color_ids.size(); i++ ) {
                    if ( doc['color.id'] == color_ids[i] ) {
                      return i;
                    }
                  }
                  return 99;
                }.gsub(/[\r\n]|([\s]{2,})/, ''),
                params: { color_ids: colors },
                type: 'number',
                order: 'asc'
              }
            })
          else
            by 'product.position', 'asc'
          end
        end
      end
    end
end
