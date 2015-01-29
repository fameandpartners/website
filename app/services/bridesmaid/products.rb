# class, designed to extract products for bridesmaid-party/dresses only
# supposed to be wrapping over products extractor/finder/repository
# implement it later
# Description:
# Display dress variants at the top of the page that match the colours the user selected 
# when they completed the questionnaire.
class Bridesmaid::Products
  attr_reader :site_version, :profile, :collection

  def initialize(options = {})
    @site_version = options[:site_version]
    @profile      = options[:profile]
    @collection   = Array.wrap(options[:collection])
    @taxon_ids    = options[:taxon_ids]
    @body_shapes  = options[:body_shapes]
  end

  def read_all
    search_results.map do |item|
      build_product(item)
    end
  end

  private

    def search_results
      @search_results ||= build_search_query.results
    end

    def taxon_ids
      [collection.map(&:id).compact, Array(@taxon_ids)]
    end

    def color_ids
      @color_ids ||= profile.color_ids
    end

=begin
    # color, and similars
    def color_ids
      # it's not cached, and will generate second request in similar_products,
      # solve it with placing similar colors search to own repo
      @color_ids ||= begin
        color_ids = profile.colors.map{|c| c[:id]}
        similar_color_ids = Similarity.get_similar_color_ids(color_ids, Similarity::Range::VERY_CLOSE)
        color_ids + similar_color_ids
      end
    end
=end

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
        color_id: item.color.id,
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
          #item.prices[currency].present? ? item.prices[currency] : nil
          item.prices.to_hash.values
        end.flatten.compact

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

    def product_discounts
      return @product_discounts if instance_variable_defined?('@product_discounts')

      @product_discounts ||= begin
        product_ids = search_results.map{|item| item.product.id }
        Repositories::Discount.read_all('Spree::Product', product_ids)
      end
    end

    def product_discount(product)
      product_discounts.find{|discount| discount.discountable_id == product.id }
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

      path_parts.push(color.name) if color.present?

      "/" + path_parts.join('/')
    end

    # first candidate to extract to repo
    def build_search_query
      # to make them visible inside Tire.search block
      colors      = color_ids
      body_shapes = @body_shapes
      taxons      = taxon_ids

      Tire.search(:color_variants, size: 1000) do
        filter :bool, :must => { :term => { 'product.is_deleted' => false } }
        filter :bool, :must => { :term => { 'product.is_hidden' => false } }
        filter :exists, :field => :available_on
        filter :bool, :should => { :range => { 'product.available_on' => { :lte => Time.now } } }

        # Filter by colors
        if colors.present?
          filter :terms, 'color.id' => colors
        end

        # only available items
        filter :bool, :must => { :term => { 'product.in_stock' => true } }

        if taxons.present?
          taxons.each do |ids|
            if ids.present?
              filter :terms, 'product.taxon_ids' => ids
            end
          end
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
