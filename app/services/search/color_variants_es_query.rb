module Search
  class ColorVariantsESQuery
    require 'elasticsearch/dsl'
    include Elasticsearch::DSL

    def self.build(options = {})      
      options = HashWithIndifferentAccess.new(options)

      # some kind of documentation
      colors            = options[:color_ids] #
      body_shapes       = options[:body_shapes] #
      taxon_ids         = options[:taxon_ids] #
      exclude_products  = options[:exclude_products]  #no!
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

      product_orderings = ProductOrdering.product_orderings(currency: currency)

      include_aggregation_prices      = options[:include_aggregation_prices]
      include_aggregation_taxons      = options[:include_aggregation_taxons]
      include_aggregation_bodyshapes  = options[:include_aggregation_bodyshapes]
      include_aggregation_color_ids   = options[:include_aggregation_color_ids]


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
            must {term 'product.is_deleted' => false}
            must {term 'product.is_hidden' => false}
            must {term 'product.is_outerwear' => show_outerwear}
            must {term 'product.in_stock' => true}

            if fast_making.present?
              must {term 'product.fast_making' => fast_making}
            end

            if taxon_ids.present?
              taxon_terms = taxon_ids.map do |tid|
                must {terms 'product.taxon_ids' => Array.wrap(tid) }
              end
            end

            # exclude products found
            if exclude_products.present?
              must_not do
                term id: exclude_products
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

            if discount.present?
              if discount == :all?
                should do
                  term range 'product.discount' => { :gt => 0 }
                end
              else
                must do
                  term 'product.discount' => discount.to_i
                end
              end
            end

            if price_mins.present? || price_maxs.present?
              filter do
                bool do
                  price_mins.zip(price_maxs).map do |min, max|
                    should do
                      range "sale_prices.#{currency}" => {gte: min, lte: max}
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

            if query_string.present?
              must do
                query_string do
                  query "product.name:(#{query_string})^4 OR color.presentation:(#{query_string})^2 OR fabric.presentation:(#{query_string})^2 OR product.sku:(#{query_string})^2 OR product.taxon_names:(#{query_string})^2 OR product.description:(#{query_string})"
                end
              end
            end
          end
        end

        if include_aggregation_color_ids
          aggregation :color_ids do
            terms do
              field "color.id"
              size 9999
            end
          end
        end

        if include_aggregation_taxons
          aggregation :taxon_ids do
            terms do
              field "product.taxon_ids"
              size 9999
            end
          end
        end

        if include_aggregation_prices
          aggregation :prices do
            range do
              field "sale_prices.#{currency}"
              key   '0-199', from: 0, to: 199
              key   '200-299', from: 200, to: 299
              key   '300-399', from: 300, to: 399
              key   '400', from: 400
            end
          end
        end

        if include_aggregation_bodyshapes
          aggregation :body_shape_ids do
            terms do
              field "product.body_shape_ids"
              size 9999
            end
          end
        end

        sort do
          if body_shapes.present?
           body_shapes.each {|bs| by "product.#{bs}", order: 'desc'}
          end

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
