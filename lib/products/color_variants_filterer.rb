module Products
  class ColorVariantsFilterer
    attr_accessor :params
    attr_accessor :currency
    attr_accessor :properties

    def initialize(params = {}, currency = 'AUD')
      self.params = params
      self.currency = currency.downcase
      self.properties = ActiveSupport::HashWithIndifferentAccess.new

      prepare(params)
    end

    def color_variants      
      @color_variants ||= search_colour_variants 
    end

    def search_colour_variants
      begin 
        if colour.blank?
          search
        else
          search(colour.map(&:id))
        end    
      rescue Errno::ECONNREFUSED => ex
        Rails.logger.error ex
        return []
      end
    end

    def similar_color_variants
      @similar_color_variants ||= begin
        return [] if colour.blank?

        @fetched_color_variant_ids = color_variants.map(&:id)
        search([], customizable_color: true)
      end
    end

    def search(color_ids = [], options = {})
      taxon_ids  = taxons.present? ? taxons : {}
      keywords   = keywords.present? ? keywords.split : []
      bodyshapes = bodyshape
      order_by   = order
      limit      = per_page
      offset     = ((page - 1) * per_page)
      fetched_color_variant_ids = @fetched_color_variant_ids
      product_discount = discount

      begin
        results = Tire.search(configatron.elasticsearch.indices.color_variants, size: 1000) do
          # Get only actual info. Ignore deleted and unavailable
          filter :bool, :must => { :term => { 'product.is_deleted' => false } }
          filter :bool, :must => { :term => { 'product.is_hidden' => false } }
          filter :exists,
                 :field => :available_on
          filter :bool,
                 :should => {
                   :range => {
                     'product.available_on' => {
                       :lte => Time.now
                     }
                   }
                 }

          if options[:customizable_color]
            filter :bool,
                   :must => {
                     :term => {
                       'product.color_customizable' => true
                     }
                   }
          end

          # Ignore already received color variants (for #similar_color_variants )
          if fetched_color_variant_ids.present?
            filter :bool, :must => {
              :not => {
                :terms => {
                  :id => fetched_color_variant_ids
                }
              }
            }
          end

          # Filter by colors
          if color_ids.present?
            filter :terms, 'color.id' => color_ids
          end

          # Filter by taxons
          if taxon_ids.present?
            taxon_ids.each do |scope_name, ids|
              filter :terms, 'product.taxon_ids' => ids
            end
          end

          # Filter by keywords
          if keywords.present?
            query :term, 'product.name' => keywords
            query :term, 'product.description' => keywords
          end

          if product_discount.present?
            if product_discount == :all
              filter :bool, :should => { :range => { "product.discount" => { :gt => 0 } } }
            else
              filter :bool, :must => { :term => { 'product.discount' => product_discount.to_i } }
            end
          end

          # Show only products from stock
          filter :bool,
                 :must => {
                   :term => {
                     'product.in_stock' => true
                   }
                 }

          # Show only products with prices
          # unless Spree::Config.show_products_without_price
          #   filter :exists, :field => :price
          # end


          # Filter by bodyshapes
          if bodyshapes.present?
            if bodyshapes.size.eql?(1)
              filter :bool, :should => {
                :range => {
                  "product.#{bodyshapes.first}" => {
                    :gte => 4
                  }
                }
              }
            else
              filter :or,
                     *bodyshapes.map do |bodyshape|
                       {
                         :bool => {
                           :should => {
                             :range => {
                               "product.#{bodyshape}" => {
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
            if color_ids.present?
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
                  params: {
                    color_ids: color_ids
                  },
                  type: 'number',
                  order: 'asc'
                }
              })
            end

            if bodyshapes.present?
              by ({
                :_script => {
                  script: bodyshapes.map{|bodyshape| "doc['product.#{bodyshape}'].value" }.join(' + '),
                  type:   'number',
                  order:  'desc'
                }
              })
            end

            case order_by
              when 'price_high'
                by 'product.price', 'desc'
              when 'price_low'
                by 'product.price', 'asc'
              when 'newest'
                by 'product.created_at', 'desc'
              when 'fast_delivery'
                by 'product.fast_delivery', 'desc'
              when 'popular'
                by 'product.position', 'asc'
              else
                by 'product.position', 'asc'
            end
          end

          from offset
          size limit
        end.results.results.to_a

        # We really need to refactor price logic, it is very...
        price_ids = results.map{ |result| result.prices.send(@currency) }
        prices = Hash[*Spree::Price.find(price_ids).map do |price|
          [price.id, price]
        end.flatten]

        results.each do |result|
          price = prices[result.prices.send(@currency)]
          result.instance_variable_set('@price', price)
          def result.price
            @price
          end
        end

        results
      rescue ActiveRecord::RecordNotFound
        Products::ColorVariantsIndexer.index!
        search(color_ids)
      end
    end


    # all methods below are copied from Products::ProductsFilter
    def method_missing(name)
      if @properties.has_key? name
        @properties[name]
      else
        super
      end
    end

    def selected_products_info
      Products::BannerInfo.new(self).get
    end

    def colors_with_similar(range = :default)
      return [] if colour.blank?
      max_diff = range == :very_close ? 15 : 30

      similar_colors = colour.map do |colour|
        colour.similars.where('similarities.coefficient < ?', max_diff)
      end.flatten
      colour + similar_colors
    end

    def selected_color_name
      colour.present? ? colour.first.name : nil
    end

    def taxons
      permalinks = Spree::Taxon.all.map(&:permalink)

      # * = splat operator
      # slice limits the hash to hold only provided values

      @properties.slice(*permalinks).reject{ |k, v| v.blank? }
    end

    def prepare(params)
     
      params = HashWithIndifferentAccess.new(params) unless params.is_a?(HashWithIndifferentAccess)
      @properties[:keywords] = params[:keywords]

      # this block works as proxy, between human readable url params like 'red', 'skirt'
      # and required for search ids
      @properties[:collection]  ||= []
      @properties[:edits]       ||= []

      @properties[:selected_taxons] ||= []
      @properties[:selected_edits] ||= []

      

      # it's dirty hack, we equal collection with some other collection
      if params[:collection].present? && params[:seocollection].blank?
        
        params[:seocollection] = params[:collection]
        @properties["collection"] = params[:collection]
        @properties["seocollection"] = params[:collection]
        # MarkoK: continuing with dirty hacks, to ensure backwards compatibility
        # with the old links, we add "collection/" to the beggining of the permalink
        params[:permalink] = "collection/#{params[:collection]}"
        
      elsif params[:collection].present?
        params[:permalink] = "collection/#{params[:collection]}"
        @properties["collection"] = params[:collection]
        
      elsif params[:edits].present?
        params[:permalink] = params[:edits]
      elsif params[:collection].blank? && params[:edits].blank? && params[:permalink].present?
        params[:permalink].downcase!
        
        params[:collection] = params[:permalink]
        params[:seocollection] = params[:collection]
        @properties["collection"] = params[:collection]
        @properties["seocollection"] = params[:collection]
      elsif params[:collection].blank? && params[:style].present?
        params[:collection] = params[:style]
      end

      # ugly, refactros ASAP
      params[:permalink].downcase! unless params[:permalink].blank?

      # adding support for faceted search (filtering) across multiple taxons
      final_requested_taxons = []

      
      # this is a really wrong way to check if both style and event contain the requested permalink...
      if params[:permalink].present?
        final_requested_taxons << "style/#{params[:permalink]}"
        final_requested_taxons << "event/#{params[:permalink]}"
        final_requested_taxons << "edits/#{params[:permalink]}"
      end
      
      #here we handle the filtering
      final_requested_taxons << "style/#{params[:style]}" unless params[:style].blank?
      final_requested_taxons << "event/#{params[:event]}" unless params[:event].blank?

     

      itsa_taxon = false

      Spree::Taxon.all.each do |taxon|
        permalink = taxon.permalink
        @properties[permalink] = prepare_taxon(permalink, final_requested_taxons)
        
        itsa_taxon = true if @properties[permalink].present?

        if @properties[permalink].present? && params[:event].blank? && !taxon.permalink.match('event').nil?
          params[:event] = params[:permalink]
        end

        if @properties[permalink].present? && params[:edits].blank?
          @properties[:selected_edits] << @properties[permalink]
        elsif @properties[permalink].present?
          @properties[:selected_taxons] << @properties[permalink]          
        end
      end

     
      
      unless itsa_taxon
        if ProductStyleProfile::BODY_SHAPES.include? params[:permalink]
          params[:bodyshape] = params[:permalink]
        else
          params[:colour] = params[:permalink]
        end
      end

      
      sale_param = "" 
      if params[:sale].present?
        sale_param = params[:sale].delete('?')
      end

      @properties[:colour]        = prepare_colours(params[:colour])
      @properties[:seo_colour]    = prepare_seo_colour(params[:colour])
      @properties[:bodyshape]     = prepare_bodyshape(params[:bodyshape])
      @properties[:discount]      = prepare_discount(sale_param)

      @properties[:search] = params[:search]

      per_page = params[:per_page].to_i
      @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
      @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
      @properties[:order] = params[:order]
    end

    def prepare_taxon(taxon_permalink, requested_permalinks)
      return nil if requested_permalinks.blank?
      permalinks = Array.wrap(requested_permalinks)

      # db_permalinks = permalinks.map{|permalink| "#{root}/#{permalink.downcase}"}
      # Spree::Taxon.select(:id).where("lower(permalink) IN (?)", db_permalinks).map(&:id)
      if permalinks.include? taxon_permalink
        r = Spree::Taxon.select(:id).where(permalink: taxon_permalink).map(&:id)
      else
        r = nil
      end

      
      return r
    end

    def prepare_colours(color_names)
      color_names = Array.wrap(color_names).map{ |name| name.to_s.downcase }
      option_type = Spree::OptionType.color

      if color_names.blank?
        []
      elsif color_names.size.eql?(1)
        group = Spree::OptionValuesGroup.where(
          ['option_type_id = ? AND LOWER(TRIM(name)) = ?', option_type.id, color_names.first]
        ).first

        if group.present?
          colors = group.option_values
        else
          colors = option_type.option_values.where(
            ['LOWER(TRIM(name)) = ?', color_names.first]
          )
        end
      else
        conditions = ['LOWER(TRIM(name)) IN (?)', color_names]
        whens = color_names.map do |color_name|
          "WHEN lower(name) = #{ActiveRecord::Base.connection.quote(color_name)} THEN #{color_names.index(color_name)}"
        end
        orderings = "CASE #{whens.join(' ')} END ASC"

        colors = option_type.option_values.
          where(conditions).
          order(orderings)
      end

      colors.to_a
    end

    def prepare_bodyshape(bodyshapes)
      return nil if bodyshapes.blank?
      bodyshapes = [bodyshapes] unless bodyshapes.is_a?(Array)
      bodyshapes.map(&:downcase)
    end

    def prepare_seo_colour(colour_names)
      (Array.wrap(colour_names) || []).first.to_s.downcase.split(/[_-]/).compact.join(' ')
    end

    # value can be 'all'
    # '20%'
    # or etc
    def prepare_discount(value = nil)
      return nil if value.blank?
      if value.to_s == 'all'
        :all
      else
        value.to_s[/^\d+/].to_i
      end
    end

    class << self
      def available_sort_orders
        [
          ['price_high', 'Price High'],
          ['price_low', 'Price Low'],
          ['newest', "What's new"],
          ['fast_delivery', 'Next day delivery']
        ]
      end
    end
  end
end
