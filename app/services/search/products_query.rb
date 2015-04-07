# adapter to search mechanics
# products search
#   query: query string
#   limit: 1000 by default  
module Search
  class ProductsQuery
    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)
      
      limit        = options[:limit].present? ? options[:limit].to_i : 1000

      query_string = Tire::Utils.escape(options[:query])

      if query_string.present?
        Tire.search(:spree_products, :load => { :include => :master }) do
          size  limit
          query do
            string query_string, :default_operator => 'OR' , :use_dis_max => true
          end
          filter :bool, :must => { :term => { :deleted => false } }
          filter :bool, :must => { :term => { :hidden => false } }
          filter :exists, :field => :available_on
          filter :bool, :should => {
            :range => {
              :available_on => { :lte => Time.now }
            }
          }
        end
      else
        FastOpenStruct.new(results: FastOpenStruct.new(results: []))
      end
    end
  end
end
