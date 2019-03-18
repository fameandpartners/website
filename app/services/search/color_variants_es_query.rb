module Search
  class ColorVariantsESQuery
    require 'elasticsearch/dsl'
    include Elasticsearch::DSL

    def self.build(options = {})      
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentation
      boost_pids        = options[:boost_pids] #
      boost_facets        = options[:boost_facets] #
      colors            = options[:color_ids] #
      color_group_names = options[:color_group_names] #
      taxon_names       = options[:taxon_names] #
      body_shapes       = options[:body_shapes] #
      taxon_ids         = options[:taxon_ids] #
      discount          = options[:discount]  #
      query_string      = options[:query_string]
      order             = options[:order]
      fast_making       = options[:fast_making]
      limit             = options[:limit].present? ? options[:limit].to_i : 1000
      offset            = options[:offset].present? ? options[:offset].to_i : 0
      price_mins         = Array.wrap(options[:price_min]).map(&:to_f)
      price_maxs         = Array.wrap(options[:price_max]).map(&:to_f)
      currency          = options[:currency]
      show_outerwear    = !!options[:show_outerwear]
      exclude_taxon_ids = options[:exclude_taxon_ids] if query_string.blank?
      exclude_taxon_names = options[:exclude_taxon_names]

      product_orderings = ProductOrdering.product_orderings(currency: currency)

      include_aggregation_prices            = options[:include_aggregation_prices]
      include_aggregation_taxons            = options[:include_aggregation_taxons]
      include_aggregation_bodyshapes        = options[:include_aggregation_bodyshapes]
      include_aggregation_color_group_names = options[:include_aggregation_color_group_names]

      product_ordering = product_orderings.fetch(order) do
        if query_string.present?
          # Do not apply ordering for searches, let ES order by term relevance.
          product_orderings['native']
        else
          product_orderings['newest']
        end
      end

      definition = Elasticsearch::DSL::Search.search do
        query do
          bool do
            filter {term 'product.is_deleted' => false}
            filter {term 'product.is_hidden' => false}
            filter {term 'product.in_stock' => true}

            if fast_making.present?
              filter {term 'product.fast_making' => fast_making}
            end

            if taxon_ids.present?
              taxon_terms = taxon_ids.map do |tid|
                filter {terms 'product.taxon_ids' => Array.wrap(tid) }
              end
            end


            # exclude items marked not-a-dress

            if exclude_taxon_ids.present?
              exclude_taxon_ids.each do |id|
                must_not do
                  term 'product.taxon_ids' => id
                end
              end
            end

            if exclude_taxon_names.present?
              exclude_taxon_names.each do |name|
                must_not do
                  term 'product.taxons.keyword' => name
                end
              end
            end

            should do
              range 'product.available_on' => {lte: Time.now}
            end

            if body_shapes.present?
              filter do
                bool do
                  body_shapes.map do |bs|
                    should do
                      range "product.#{bs}" => {gte: 4}
                    end
                  end
                end
              end
            end

            if price_mins.present? || price_maxs.present?
              filter do
                bool do
                  price_mins.zip(price_maxs).map do |min, max|
                    should do
                      range "prices.#{currency}" => {gte: min, lte: max}
                    end
                  end
                end
              end
            end
            if colors.present?
              filter do
                bool do
                  colors.map do |color|
                    should do
                      term 'color.id' => color
                    end
                  end
                end
              end
            end

            if color_group_names.present?
              must do
                bool do
                  color_group_names.map do |color|
                    should do
                      term 'product.taxons.keyword': { value: color, boost: 1 }
                    end
                  end
                end
              end
            end

            if taxon_names.present?
              filter do
                bool do
                  taxon_names.map do |taxon|
                    must do
                      term 'product.taxons.keyword' => taxon
                    end
                  end
                end
              end
            end

            if query_string.present?
              must do
                multi_match do
                  query query_string
                  type :phrase
                  fields ['product.name^4', 'color.presentation^2', 'fabric.presentation^2', 'product.sku^4', 'product.taxons^2', 'product.description']
                end
              end
            end

            if boost_pids && !boost_pids.empty?
              boost_pids.map.with_index do |bp, index|
                should do
                  term 'product.pid.keyword': { value: bp, boost: 200-index }
                end
              end
            end

            if boost_facets && !boost_facets.empty?
              boost_facets.map.with_index do |bf, index|
                should do
                  term 'product.taxons.keyword': { value: bf, boost: 100-index }
                end
              end
            end
          end
        end

        if include_aggregation_color_group_names
          aggregation :color_group_names do
            terms do
              field "product.taxons.keyword"
              size 9999
            end
          end
        end

        if include_aggregation_taxons
          aggregation :taxons do
            terms do
              field "product.taxons.keyword"
              size 9999
            end
          end
        end

        if include_aggregation_prices
          aggregation :prices do
            range do
              field "prices.#{currency}"
              key   '0-199', from: 0, to: 199
              key   '200-299', from: 200, to: 299
              key   '300-399', from: 300, to: 399
              key   '400', from: 400
            end
          end
        end

        sort do         
          by "_score", order: 'desc'
 
          if colors.present?
           by "color.id", order: 'asc'
          end

          if product_ordering[:behaviour].present?
            by product_ordering[:behaviour].first, product_ordering[:behaviour].last
          end

        end
      end

      definition
    end
  end
end
