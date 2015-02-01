require 'elasticsearch/persistence'

class LandingPage::ProductRepository
  include Elasticsearch::Persistence::Repository
  attr_accessor :options

  def initialize(options={})
    @options = options
    index(:color_variants)
    client(init_client)
  end

  def products
    search(query)
  end

  def query
    {
      :query => has_keywords,
      :filter => {
        :and => filters
      },
      :size => options[:size] || 1 
    }.select { |_, v| !v.nil? }
  end

  def filters
    [is_current, is_visible, is_available, has_taxons].compact.flatten
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
          'color.id' => option[:color_ids]
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
   # if product_discount.present?
   #    if product_discount == :all
   #      filter :bool, :should => { :range => { "product.discount" => { :gt => 0 } } }
   #    else
   #      filter :bool, :must => { :term => { 'product.discount' => product_discount.to_i } }
   #    end
   #  end
  end

  def has_any_discount
    {
      :bool => {
        :should => { 
          :range => { 
            'product.discount' => {
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
            'product.discount' => options[:discount].to_i 
          }
        } 
      }
    }
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

  def is_color_customizable
    if options[:color_customizable]
      is_true('product.color_customizable')
    end
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

  def init_client
    url = 'http://localhost:9200' #Rails.configuration.elasticsearch.url = 
    Elasticsearch::Client.new(url: url, log: true)
  end

end