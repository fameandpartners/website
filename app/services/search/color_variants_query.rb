# adapter to search mechanics
# it's wrong idea to call external libraries directly & in many places
# handle all color variant search logic here
#
# Search::ColorVariantsQuery.build(
#   color_ids: []     color variant should have exactly this color
#   body_shapes: []   color variant product should have exactly this shape
#   taxon_ids: []     color variant product should belongs to this taxons
#   exclude_products: don't search this products
#   order:            ['price_high', 'price_low', 'newest', 'fast_deliver']
#   discount:         search products with specific discount ( in percents ) or :all to find all products under sale
#   query_string:     search products by this text
#   fast_making:      search by express delivery [ available or not ]
#   limit:            1000 by default
#   offset:           0 by default
# )
module Search
  class ColorVariantsQuery
    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentation
      colors            = options[:color_ids]
      body_shapes       = options[:body_shapes]
      taxons            = options[:taxon_ids]
      exclude_products  = options[:exclude_products]
      discount          = options[:discount]
      query_string      = options[:query_string]
      order             = options[:order]
      fast_making       = options[:fast_making]
      limit             = options[:limit].present? ? options[:limit].to_i : 1000
      offset            = options[:offset].present? ? options[:offset].to_i : 0
      price_min        = options[:price_min]
      price_max        = options[:price_max]
      currency         = options[:currency]
      show_outerwear    = !!options[:show_outerwear]
      exclude_taxon_ids = options[:exclude_taxon_ids]

      order = 'created' if order.blank? && query_string.blank?

      Tire.search(configatron.elasticsearch.indices.color_variants, size: limit, from: offset) do

        filter :bool, :must => { :term => { 'product.is_deleted' => false } }
        filter :bool, :must => { :term => { 'product.is_hidden' => false } }
        filter :exists, :field => :available_on
        filter :bool, :should => { :range => { 'product.available_on' => { :lte => Time.now } } }

        # Filter by colors
        if colors.present?
          filter :terms, 'color.id' => colors
        end

        # Outerwear filter
        filter :bool, :must => { :term => { 'product.is_outerwear' => show_outerwear } }

        # only available items
        filter :bool, :must => { :term => { 'product.in_stock' => true } }

        # not defined /  only false / only true
        unless fast_making.nil?
          filter :bool, :must => { :term => { 'product.fast_making' => fast_making } }
        end

        if taxons.present?
          filter :terms, 'product.taxon_ids' => taxons
        end

        # exclude items marked not-a-dress
        if exclude_taxon_ids.present?
          filter :bool, :must => {
            :not => {
              :terms => {
                'product.taxon_ids' => exclude_taxon_ids
              }
            }
          }
        end

        # select only products with given discount
        if discount.present?
          if discount == :all
            filter :bool, :should => { :range => { "product.discount" => { :gt => 0 } } }
          else
            filter :bool, :must => { :term => { 'product.discount' => discount.to_i } }
          end
        end

        if price_min.present?
          filter :bool, :should => { :range => { "sale_prices.#{currency}" => { :gt => price_min } } }
        end

        if price_max.present?
          filter :bool, :should => { :range => { "sale_prices.#{currency}" => { :lt => price_max } } }
        end

        if query_string.present?
          query_string = query_string.downcase.gsub("dresses","").gsub("dress","")
          query do
            string "product.name:(#{query_string})^4 OR color.name:(#{query_string})^2 OR product.sku:(#{query_string})^2 OR product.taxon_names:(#{query_string})^2 OR product.description:(#{query_string})"
          end
        end

        # exclude products found [ somethere else ]
        if exclude_products.present?
          filter :bool, :must => {
            :not => {
              :terms => {
                :id => exclude_products
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
            filter :bool, :should =>[ body_shapes.map do |bs| { :range => {"product.#{bs}" => {:gte => 4} }} end ]
          end
        end

        sort do
          if colors.present?
            by ({
              :_script => {
                script: %q{
                  for ( int i = 0; i < color_ids.size(); i++ ) {
                    if ( doc['color.id'].first() == color_ids[i] ) {
                      return i;
                    }
                  }
                }.gsub(/[\r\n]|([\s]{2,})/, ''),
                params: { color_ids: colors },
                type: 'number',
                order: 'asc'
              }
            })
          end

          if body_shapes.present?
            by ({
              :_script => {
                script: body_shapes.map{|bodyshape| "doc['product.#{bodyshape}'].value" }.join(' + '),
                type:   'number',
                order:  'desc'
              }
            })
          end

          case order
            when 'price_high'
              by 'product.price', 'desc'
            when 'price_low'
              by 'product.price', 'asc'
            when 'newest'
              by 'product.created_at', 'desc'
            when 'oldest'
              by 'product.created_at', 'asc'
            when 'fast_delivery'
              by 'product.fast_delivery', 'desc'
            when 'best_sellers'
              by 'product.total_sales', 'desc'
            when 'alpha_asc'
              by 'product.name', 'asc'
            when 'alpha_desc'
              by 'product.name', 'desc'
            when 'created'
              by 'product.created_at', 'desc'
            else
              # Don't have an order here, so this will show any queried dress first in the result,
              # eg, search for 'last Kiss' will show 'last kiss' then 'studded kiss' instead of
              # 'studded kiss' then 'last kiss' which was happening prior.
          end
        end
      end
    end
  end
end
