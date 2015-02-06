# adapter to search mechanics
# it's wrong idea to call external libraries directly & in many places
# handle all color variant search logic here
#
# Search::ColorVariantsQuery.build(
#   color_ids: []     color variant should have exactly this color
#   body_shapes: []   color variant product should have exactly this shape
#   taxon_ids: []     color variant product should belongs to this taxons
#   exclude_products: don't search this products
#   limit:            1000 by default
# )
module Search
  class ColorVariantsQuery
    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentations
      colors              = options[:color_ids]
      body_shapes         = options[:body_shapes]
      taxons              = options[:taxon_ids]
      exclude_products    = options[:exclude_products]
      limit               = options[:limit].present? ? options[:limit].to_i : 1000

      Tire.search(:color_variants, size: limit) do
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
end
