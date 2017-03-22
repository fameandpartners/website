#= require 'templates/_product'
#= require 'templates/product_collection'
#= require 'templates/product_collection_append'
#= require 'templates/product_collection_filter'
#= require 'templates/product_collection_sort'
window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']
  collectionMoreTemplate: JST['templates/product_collection_append']
  collectionFilterResultTemplate: JST['templates/product_collection_filter']
  collectionSortResultTemplate: JST['templates/product_collection_sort']

  constructor: (options = {}) ->
    options = $.extend({
      reset_source: true,
      page_size: 21,
      mobileBreakpoint: 768,
      mobileFilterSelector: '.js-trigger-filter-mobile',
      mobileSortSelector: '.js-trigger-sort-mobile',
      showMoreSelector: "*[data-action=show-more-collection-products]",
      ORDERS : {
        newest: 'What\'s New',
        price_high: 'Price High to Low',
        price_low: 'Price Low to High',
      }

    }, options)
    @details_elements = options.details_elements || {}
    @filter = $(options.controls)
    @content = $(options.content)

    # Sorting / Filtering
    @sortMetaContent = $(options.sortMetaContent)
    @filterMetaContent = $(options.filterMetaContent)
    @mobileFilter = $(options.mobileFilterSelector)
    @mobileSort = $(options.mobileSortSelector)
    @mobileFilter.on('click', @toggleFilters)
    @mobileSort.on('click', @toggleSort)
    # base
    # if users comes by url with specific params, like /dresses/for/very/special/case
    # then use this path until user selects another collection
    @source_path = window.location.pathname || '/dresses'

    # allow user to leave /dresses/for/very/special/case collection
    # or navigate only in it
    @reset_source = options.reset_source

    @mobileBreakpoint = options.mobileBreakpoint

    # pagination
    @page_size = options.page_size
    @ORDERS = options.ORDERS
    @showMoreSelector = options.showMoreSelector
    @resetPagination(options.size, options.total_products)
    @content.on('click', @showMoreSelector, @showMoreProductsClickHandler)
    $(window).on('scroll', @scrollHandler)

    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))
    @productOrderInput.on('change', @update)
    @$banner = $(options.banner)

  toggleFilters:(forceToggle) ->
    $('.ExpandablePanel-filter--mobile').toggleClass('ExpandablePanel--mobile--isOpen', forceToggle)
  toggleSort:(forceToggle) ->
    $('.ExpandablePanel-sort--mobile').toggleClass('ExpandablePanel--mobile--isOpen', forceToggle)

  filterSortMetaDescription:(updateRequestParams) ->
    metaDescription = {
      sortDescription: @ORDERS['newest'],
      totalFilters: 0
    }
    console.log(updateRequestParams)
    if updateRequestParams.fast_making
      metaDescription.totalFilters++
    if updateRequestParams.price_max && updateRequestParams.price_min
      metaDescription.totalFilters++
    if updateRequestParams.bodyshape && updateRequestParams.bodyshape.length
      metaDescription.totalFilters++
    if updateRequestParams.color && updateRequestParams.color.length
      metaDescription.totalFilters++
    if updateRequestParams.fastMaking && updateRequestParams.fastMaking.length
      metaDescription.totalFilters++
    if @ORDERS[updateRequestParams.order]
      metaDescription.sortDescription = @ORDERS[updateRequestParams.order]
    metaDescription

  resetPagination: (items_on_page, total_records) ->
    @products_on_page = items_on_page
    @total            = total_records
    @updatePaginationLink('active')

  updateMetaDescriptionSpan:(metaDescription) ->
    @resultsMeta = {
      filterText: '(' + metaDescription.totalFilters + ')',
      sortText: metaDescription.sortDescription
    }
    content_sort_html = @collectionSortResultTemplate(resultsMeta: @resultsMeta)
    @sortMetaContent.html(content_sort_html)

    content_filter_html = @collectionFilterResultTemplate(resultsMeta: @resultsMeta)
    @filterMetaContent.html(content_filter_html)

  updatePagination: (items_added, total_records) ->
    if items_added == 0
      @products_on_page = total_records
    else
      @products_on_page += items_added
    @total            = total_records
    @updatePaginationLink('active')

  updatePaginationLink: (state = 'active') ->
    row = @content.find(@showMoreSelector).closest('.more-products')
    row.find('.status').hide()
    if state == 'loading'
      row.find('.loading').show()
    else if state == 'inactive'
      row.hide()
    else # active
      if @products_on_page < @total
        row.find('.active').show()
      else
        row.hide()

  update: (updateRequestParams) =>
    metaDescription = @filterSortMetaDescription(updateRequestParams)
    @toggleFilters(false)
    @source_path = '/dresses' if @reset_source
    updateRequestParams = updateRequestParams || _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    @updatePaginationLink('inactive')
    $.ajax(urlWithSitePrefix(@source_path),
      type: "GET",
      dataType: 'json',
      data: $.param(_.extend(updateRequestParams, { limit: @page_size })),
      success: (collection) =>
        # Replace content HTML
        content_html = @collectionTemplate(collection: collection)
        @content.html(content_html)
        @resetPagination(collection.products.length, collection.total_products)
        @updateMetaDescriptionSpan(metaDescription)
        if collection && collection.details
          @updateCollectionDetails(collection.details)

        track.pageView(pageUrl, updateRequestParams)
    )

  showMoreProductsClickHandler: (e) =>
    e.preventDefault()
    if @loading != true
      @loading = true
      updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
      @updatePaginationLink('loading')
      $.ajax(urlWithSitePrefix(@source_path),
        type: "GET",
        dataType: 'json',
        data: $.param(_.extend(updateRequestParams, { limit: @page_size, offset: @products_on_page })),
        success: (collection) =>
          content_html = @collectionMoreTemplate(collection: collection, col: 3)
          @content.find(@showMoreSelector).closest('.more-products').before(content_html)
          @updatePagination(collection.products.length, collection.total_products)

          if collection && collection.details
            @updateCollectionDetails(collection.details)
      ).always( =>
        @loading = false
      )

  # private methods
  getSelectedValues: () ->
    bodyshapeArray = []
    colorArray = []
    styleArray = []
    fastmakingArray = []
    priceHash = {}

    if $("#collapse-color .js-filter-all input:not(:checked)")
      colorInputs = $("#collapse-color input:not(.js-filter-all):checked")
      for colorInput in colorInputs
        colorArray.push($(colorInput).attr("name"))
      color = $("#other-colors option:selected").attr("name")
      if color != "none"
        colorArray.push(color)

    if $("#collapse-bodyshape .js-filter-all input:not(:checked)")
      bodyshapeInputs = $("#collapse-bodyshape input:not(.js-filter-all):checked")
      for bodyshapeInput in bodyshapeInputs
        bodyshapeArray.push($(bodyshapeInput).attr("name"))

    if $("#collapse-style .js-filter-all input:not(:checked)")
      styleInputs = $("#collapse-style input:not(.js-filter-all):checked")
      for styleInput in styleInputs
        styleArray.push($(styleInput).attr("name"))

    if $("#collapse-delivery-date .js-filter-all input:not(:checked)")
      fastmakingInput = $("#collapse-delivery-date input:not(.js-filter-all):checked")
      fastmakingArray.push(true) if fastmakingInput.is(":checked")

    filter =  {
      bodyshape: bodyshapeArray,
      color: colorArray,
      style: styleArray,
      fast_making: fastmakingArray,
      order: @productOrderInput.val()
      q:         getUrlParameter("q")?.replace(/\+/g," ")
    }

    if $(".selector-price input:checked").data("all") == false
      priceMinArr = []
      priceMaxArr = []
      priceMins = $(".selector-price input:checked")
      for e in priceMins
        priceMinArr.push $(e).data("pricemin")
      priceMaxs = $(".selector-price input:checked")
      for e in priceMaxs
        priceMaxArr.push $(e).data("pricemax") || 5000
      priceHash["price_min"] = priceMinArr
      priceHash["price_max"] = priceMaxArr if priceMaxArr?
      filter = $.extend(filter,priceHash)

    filter

  updatePageLocation: (filter) ->
    source = _.clone(@source_path)
    filter = _.compactObject(filter || {})
    if _.isEmpty(filter)
      url = source
    else
      url = "#{ source }?#{ $.param(filter) }"

    url = urlWithSitePrefix(url)
    window.history.pushState({ path: url }, '', url)
    url

  scrollHandler: (e) =>
    $el = $(@showMoreSelector)
    if $el.is(':visible')
      $window = $(window)
      top = $window.scrollTop()
      bottom = top + $window.height()

      elTop = $el.offset().top - 120 #load a bit early
      elBottom = elTop + $el.height();

      if ((elBottom <= bottom) && (elTop >= top))
        $el.click()

  updateCollectionDetails: (details) =>
    return if !@details_elements
    return if !details

    $('title').html(details.title) if details.title
    $('meta[name=description]').attr('content', details.description) if details.description

    if @details_elements.banner && details.banner
      $(@details_elements.banner.title).html(details.banner.title) if details.banner.title
      $(@details_elements.banner.description).html(details.banner.description) if details.banner.description
