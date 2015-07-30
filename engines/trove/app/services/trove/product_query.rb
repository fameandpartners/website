class Trove::ProductQuery
  attr_accessor :options, :zone

  def initialize(options={})
    @options = options
    @zone = options[:zone] || 'us'
  end

  def build
    compact_hash  :query  => featured,
                  :filter => filters,
                  :sort   => sorters
                  # :size   => options[:size] || 99
  end

  def queries
    {
      :bool => {
        :must   => [has_keywords, featured].compact.flatten
       }
    }
  end


  def filters
    {
      :bool => {
        :must   => [is_current, is_visible, is_in_stock, is_available, has_taxons, has_colors, has_discount].compact.flatten,
        :should => has_bodyshapes,
       }
    }
  end

  def sorters
    [sort_by, sort_by_color_ids].compact
  end

  def has_taxons
    if options[:taxon_ids]
      {
        'terms' => {
          'product.taxon_ids' => options[:taxon_ids]
        }
      }
    end
  end

  def has_colors
    if options[:color_ids]
      {
        'terms' => {
          'color.id' => options[:color_ids]
        }
      }
    end
  end

  def featured
    if options[:featured]
      {
        'function_score' => {
          'functions' => [
            {
              'weight' => 10,
              'filter' => {
                'terms' => {
                  'product.sku' => options[:featured]
                }
              }
            }
          ]
        }
      }
    end
  end


  def has_keywords
    if options[:keywords]
      {
        :multi_match => {
          :query  =>  options[:keywords],
          :fields =>  ['product.name^2', 'product.description']
        }
      }
    end
  end

  def has_discount
    if options[:discount]
      if options[:discount] == :all
        has_any_discount
      else
        has_discount_value
      end
    end
  end

  def discount_field
    "product.zones.#{zone}.discount"
  end

  def has_any_discount
    {
      :bool => {
        :should => {
          :range => {
            discount_field => {
              :gt => 0
            }
          }
        }
      }
    }
  end

  def has_discount_value
    {
      :bool => {
        :must => {
          :term => {
            discount_field => options[:discount].to_i
          }
        }
      }
    }
  end

  def has_bodyshapes
    if options[:bodyshapes]
      bodyshapes
    end
  end

  def bodyshapes
    Array.wrap(options[:bodyshapes]).collect do |bodyshape|
      {
       :bool => {
         :should => {
           :range => {
             "product.bodyshapes.#{bodyshape}" => {
               :gte => 4
             }
           }
         }
       }
      }
    end
  end

  def is_current
   is_false('product.is_deleted')
  end

  def is_visible
    is_false('product.is_hidden')
  end

  def is_in_stock
    is_true('product.in_stock')
  end

  def is_available
    [
      {
        :exists => {
          :field => 'product.available_on'
        }
      },
      {
        :bool => {
          :should => {
            :range => {
              'product.available_on' => {
                :lte => Time.zone.now
              }
            }
          }
        }
      }
    ]
  end

  def sort_by
    if options[:sort_by]
      {
        options[:sort_by] => options[:sort_dir] || 'desc'
      }
    # else
    #   {
    #     'product.position' => 'asc'
    #   }
    end
  end

  def sort_by_color_ids
    if options[:color_ids]
      {
        :_script => {
          script: color_id_sort_script,
          params: {
            color_ids: options[:color_ids]
          },
          type: 'number',
          order: 'asc'
        }
      }
    end
  end

  def color_id_sort_script
    %q{
      for ( int i = 0; i < color_ids.size(); i++ ) {
        if ( doc['color.id'].first() == color_ids[i] ) {
           return i;
        }
      }
    }.gsub(/[\r\n]|([\s]{2,})/, '')
  end

  def sort_by_bodyshapes
    # if bodyshapes.present?
    #   by ({
    #     :_script => {
    #       script: bodyshapes.map{|bodyshape| "doc['product.#{bodyshape}'].value" }.join(' + '),
    #       type:   'number',
    #       order:  'desc'
    #     }
    #   })
    # end
  end

  def is_false(field)
    field_is_bool(field, false)
  end

  def is_true(field)
    field_is_bool(field, true)
  end

  def field_is_bool(field, t_or_f)
    {
      :bool => {
        :must => { :term => { field => t_or_f }}
      }
    }
  end

  def compact_hash(h)
    h.select { |_, v| !v.nil? }
  end

  def script_debugger
    {
      :script_fields => {
        :test => {
          :script => color_id_sort_script,
          :params => {
            :color_ids => options[:color_ids]
          }
        }
      }
    }
  end
end
