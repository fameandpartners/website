# adapter to search mechanics
# products search
#   query: query string
#   limit: 1000 by default  
module Search
  class ProductsQuery
    def self.build(options = {})
      options = HashWithIndifferentAccess.new(options)

      query_string = options[:query]
      limit        = options[:limit].present? ? options[:limit].to_i : 1000

      if query_string.present?
        Tire.search(:spree_products, :load => { :include => :master }) do
          size  limit
          query do
            string Tire::Utils.escape(query_string), :default_operator => 'AND' , :use_dis_max => true
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
        OpenStruct.new(results: OpenStruct.new(results: []))
      end
    end
  end
end
