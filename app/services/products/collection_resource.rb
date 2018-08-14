# should be loaded automatically
#require File.join(Rails.root, 'app', 'presenters', 'products', 'collection_presenter.rb')
# Usage:
#  Products::CollectionResource.new
#    site_version: current_site_version,
#    collection:     params[:collection], # range!
#    style:          params[:style],
#    event:          params[:event],
#    color_group:    # color group, will be search by its members
#    color:          # exact color, will be searched with similarities
#    bodyshape:      params[:bodyshape],
#    discount:       params[:sale] || params[:discount],
#    fast_making:    params[:fast_making],
#    order:          params[:order]
#    limit:          # number of records
#    offset:         # number of records to skip

# NOTE:
# collection, contained 'some query' - not very correct semantically,
# so possible we should create base collection and inherit from it
# search collection & products collection
#
class Products::CollectionResource
  EXCLUDED_TAXONS_NAME = %w(not-a-dress plus-size excluded-from-site)

  attr_reader :site_version
  attr_reader :collection
  attr_reader :styles
  attr_reader :edits
  attr_reader :event
  attr_reader :bodyshape
  attr_reader :color, :color_group, :color_groups
  attr_reader :discount
  attr_reader :fast_making
  attr_reader :query_string
  attr_reader :show_outerwear
  attr_reader :order
  attr_reader :limit
  attr_reader :offset
  attr_reader :price_min
  attr_reader :price_max
  attr_reader :remove_excluded_from_site_logic

  def initialize(options = {})
    @site_version                    = options[:site_version] || SiteVersion.default
    @collection                      = Repositories::Taxonomy.get_taxon_by_name(options[:collection])
    @styles                          = Array.wrap(Repositories::Taxonomy.get_taxon_by_name(options[:style]))
    @edits                           = Repositories::Taxonomy.get_taxon_by_name(options[:edits])
    @event                           = Repositories::Taxonomy.get_taxon_by_name(options[:event])
    @bodyshape                       = Repositories::ProductBodyshape.get_by_name(options[:bodyshape])
    @color_group                     = Repositories::ProductColors.get_group_by_name(options[:color_group])
    @color_groups                    = collect_color_groups( options[:color_groups] )
    @color                           = Repositories::ProductColors.get_by_name(options[:color])
    @discount                        = prepare_discount(options[:discount])
    @fast_making                     = options[:fast_making]
    @show_outerwear                  = options[:show_outerwear]
    @query_string                    = options[:query_string]
    @order                           = options[:order]
    @limit                           = options[:limit]
    @offset                          = options[:offset]
    @price_min                       = options[:price_min]
    @price_max                       = options[:price_max]

    # TODO: delete this bad named variable: "remove_excluded_from_site_logic".
    @remove_excluded_from_site_logic = options[:remove_excluded_from_site_logic]
  end


  # what about ProductCollection class
  def read
    color     = color.first if color.is_a? Array
    bodyshape = bodyshape.first if bodyshape.is_a? Array

    Products::CollectionPresenter.from_hash(
      products:       products,
      total_products: total_products,
      collection:     collection,
      style:          styles.first,
      styles:         styles,
      event:          event,
      bodyshape:      bodyshape,
      color:          color_group.try(:[], :representative) || color,
      sale:           discount,
      fast_making:    fast_making,
      query_string:   query_string,
      order:          order,
      details:        details,
      site_version:   site_version
    )
  end

  private

  def collect_color_groups(color_group_names)
    color_group_names = Array.wrap(color_group_names)

    if color_group_names.present?
      color_group_names.collect do |group_name|
        Repositories::ProductColors.get_group_by_name(group_name)
      end.compact
    else
      nil
    end
  end

  def details
    @details ||=
      Products::CollectionDetails.new(
        collection:     collection,
        style:          styles.first,
        event:          event,
        edits:          edits,
        bodyshape:      bodyshape,
        color:          color_group.try(:[], :representative) || color,
        discount:       discount,
        site_version:   site_version,
        fast_delivery:  fast_delivery?,
        fast_making:    fast_making
      ).read
  end

  def prepare_discount(value = nil)
    return nil if value.blank?
    if value.to_s == 'all'
      :all
    else
      value.to_s[/^\d+/].to_i
    end
  end

  def query
    @query ||= Search::ColorVariantsESQuery.build(query_options)
  end

  def query_options
    result = { taxon_ids: [] }

    result[:taxon_ids].push(collection.id) if collection.present?
    styles.compact.each do |s|
      result[:taxon_ids].push(s.id)
    end
    result[:taxon_ids].push(edits.id) if edits.present?
    result[:taxon_ids].push(event.id) if event.present?

    result[:body_shapes] = Array.wrap(bodyshape) if bodyshape.present?

    # if we have shown group ( through group.representative, it will be sent back )
    # ignore this case.
    # also, having ability to query group=black&color=white seems useless
    result[:color_ids] = []

    if color_group.present?
      result[:color_ids] += color_group[:color_ids]
    elsif color_groups.present?
      color_groups.each { |c| result[:color_ids] += c[:color_ids] }
    elsif color.present?
      Array.wrap(color).compact.each do |c|
        result[:color_ids] << c[:id]
        result[:color_ids] += Repositories::ProductColors.get_similar(c[:id], Similarity::Range::DEFAULT)
      end
    end

    # TODO: delete this bad named variable: "remove_excluded_from_site_logic".
    result[:exclude_taxon_ids] = remove_excluded_from_site_logic ? nil : black_hole_taxon_ids - result[:taxon_ids]

    result[:discount]     = discount if discount.present?
    result[:fast_making]  = fast_making unless fast_making.nil?
    result[:query_string] = query_string if query_string.present?
    result[:order]        = order if order.present?
    @size                 = limit if limit.present?
    @offset              = offset if offset.present?
    result[:price_min]    = price_min if price_min.present?
    result[:price_max]    = price_max if price_max.present?
    result[:currency]     = current_currency
    # Outerwear
    result[:show_outerwear] = show_outerwear

    result
  end

  def total_products
    results["hits"]["total"]
  rescue Exception => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
    0
  end

  def results
    @results ||= Elasticsearch::Client.new(host: configatron.es_url || 'localhost:9200').search(
        index: configatron.elasticsearch.indices.color_variants,
        body: query,
        size: @size || 10,
        from: @offset || 0

      )
  end

  def products
    results_ary = results["hits"]["hits"]

    result = results_ary.map do |cvar|
      cvar = cvar['_source']
      discount = Repositories::Discount.get_product_discount(cvar["product"]["id"])
      color    = Repositories::ProductColors.read(cvar["color"]["id"])
      price    = Spree::Price.new(amount: cvar["prices"][current_currency], currency: current_currency)

      puts cvar["product"]
      Products::Presenter.new(
        id:             cvar["product"]["id"],
        sku:            cvar["product"]["sku"],
        name:           cvar["product"]["name"],
        color:          OpenStruct.new(cvar["color"]),
        fabric:         OpenStruct.new(cvar["fabric"]),
        images:         cropped_images(cvar),
        price:          price,
        discount:       discount,
        fast_delivery:  cvar["product"]["fast_delivery"],
        fast_making:    cvar["product"]["fast_making"],
        super_fast_making:    cvar["product"]["super_fast_making"]

      )
    end

    # apply custom order
    if order.blank? && color.blank? && styles.blank?
      result = Products::ProductsSorter.new(products: result).sorted_products
    end

    result
  rescue Exception => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
    []
  end

  # TODO - Consolidate with behaviour on app/helpers/landing_pages_helper.rb:24 #cropped_product_hoverable_images
  def cropped_images(color_variant)
    color_variant["cropped_images"].presence || begin
                                               # TODO Remove this block once indexes are live on production - 20150522
                                               Rails.logger.warn 'Building Product Cropped images on render'
                                               cropped_images = color_variant["images"].select{ |i| i["large"].to_s.downcase.include?('crop') }

                                               if cropped_images.blank?
                                                 cropped_images = color_variant["images"].select { |i| i["large"].to_s.downcase.include?('front') }
                                               end

                                               cropped_images.sort_by!{ |i| i["position"] }
                                               cropped_images.collect{ |i| i.try("large") }
                                             end
  end

  def current_currency
    @current_currency ||= (site_version.try(:currency).to_s.downcase || 'usd')
  end

  def fast_delivery?
    order == 'fast_delivery'
  end

  def black_hole_taxon_ids
    @black_hole_taxon_ids ||= Spree::Taxon.where(name: EXCLUDED_TAXONS_NAME).pluck(:id)
  end
end
