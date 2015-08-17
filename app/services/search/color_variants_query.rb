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
      colors           = options[:color_ids]
      body_shapes      = options[:body_shapes]
      taxons           = options[:taxon_ids]
      exclude_products = options[:exclude_products]
      discount         = options[:discount]
      query_string     = options[:query_string]
      order            = options[:order]
      fast_making      = options[:fast_making]
      limit            = options[:limit].present? ? options[:limit].to_i : 1000
      offset           = options[:offset].present? ? options[:offset].to_i : 0
      show_jackets     = !!options[:show_jackets]

      Tire.search(configatron.elasticsearch.indices.color_variants, size: limit, from: offset) do
        filter :bool, :must => { :term => { 'product.is_deleted' => false } }
        filter :bool, :must => { :term => { 'product.is_hidden' => false } }
        filter :exists, :field => :available_on
        filter :bool, :should => { :range => { 'product.available_on' => { :lte => Time.now } } }

        # Filter by colors
        if colors.present?
          filter :terms, 'color.id' => colors
        end

        # Jackets filter
        filter :bool, :must => { :term => { 'product.is_jacket' => show_jackets } }

        # only available items
        filter :bool, :must => { :term => { 'product.in_stock' => true } }

        # not defined /  only false / only true
        unless fast_making.nil?
          filter :bool, :must => { :term => { 'product.fast_making' => fast_making } }
        end

        if taxons.present?
          taxons.each do |ids|
            if ids.present?
              filter :terms, 'product.taxon_ids' => Array.wrap(ids)
            end
          end
        end

        # select only products with given discount
        if discount.present?
          if discount == :all
            filter :bool, :should => { :range => { "product.discount" => { :gt => 0 } } }
          else
            filter :bool, :must => { :term => { 'product.discount' => discount.to_i } }
          end
        end

        if query_string.present?
          query do
            string "product.name:(#{query_string})^2 product.sku:(#{query_string})"
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
            when 'fast_delivery'
              by 'product.fast_delivery', 'desc'
            else
              by 'product.position', 'asc'
          end
        end
      end
    end
  end
end
