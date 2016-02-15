#= require 'templates/_product'
#= require 'templates/product_collection'
#= require 'templates/product_collection_append'

window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']
  collectionMoreTemplate: JST['templates/product_collection_append']

  constructor: (options = {}) ->
    options = $.extend({
      reset_source: true,
      page_size: 21,
      showMoreSelector: "*[data-action=show-more-collection-products]"
		}, options)

    @details_elements = options.details_elements || {}
    @filter = $(options.controls)
    @content = $(options.content)

    # base
    # if users comes by url with specific params, like /dresses/for/very/special/case
    # then use this path until user selects another collection
    @source_path = window.location.pathname || '/dresses'

    # allow user to leave /dresses/for/very/special/case collection
    # or navigate only in it
    @reset_source = options.reset_source

    # pagination
    @page_size = options.page_size
    @resetPagination(options.size, options.total_products)
    @showMoreSelector = options.showMoreSelector
    $('#filter-accordion input').on('change', @showMoreSelector, @showMoreProductsClickHandler)
    $(window).on('scroll', @scrollHandler)

    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @setUpFilterElements()
    @productOrderInput.on('change', @update)
    @$banner = $(options.banner)

  setUpFilterElements: =>
    $(".search-filters :input").on 'change', (e) =>
      @update()

    $(".js-clear-all-filters").on('click', @clearAllOptions)

    $("#filter-mobile").on 'click', ->
      $('.filter-col').toggleClass("slide-in")
    $(".filter-rect .close").on 'click', ->
      $('.filter-col').toggleClass("slide-in")

    $(document).on 'click', (e) ->
      close = $('.filter-col .close')
      closeX = close.position()?.left + close.width() + 20
      $('.filter-col').removeClass("slide-in") if e.clientX > closeX and $('.filter-col').hasClass("slide-in")

    slideDistance = 70
    $(document).on('mousedown touchstart', (e) =>
       @xDown = e.originalEvent.x
     ).on 'mouseup touchend', (e2) =>
       @xUp = e2.originalEvent.x
       if @xDown > @xUp + slideDistance and $('.filter-col').hasClass("slide-in")
         $('.filter-col').removeClass("slide-in")

  clearAllOptions: =>
    $('.select-color select').val("none").trigger("change")
    @update()

  resetPagination: (items_on_page, total_records) ->
    @products_on_page = items_on_page
    @total            = total_records
    @updatePaginationLink('active')

  updatePagination: (items_added, total_records) ->
    if items_added == 0
      @products_on_page = total_records
    else
      @products_on_page += items_added
    @total            = total_records
    @updatePaginationLink('active')

  updatePaginationLink: (state = 'active') ->
    row = @content.find(@showMoreSelector).closest('.row.more-products')
    row.find('.status').hide()
    if state == 'loading'
      row.find('.loading').show()
    else if state == 'inactive'
      row.find('.inactive').show()
    else # active
      if @products_on_page < @total
        row.find('.active').show()
      else
        row.find('.inactive').show()

  update: () =>
    @source_path = '/dresses' if @reset_source
    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    @updatePaginationLink('inactive')
    $.ajax(urlWithSitePrefix(@source_path),
      type: "GET",
      dataType: 'json',
      data: $.param(_.extend(updateRequestParams, { limit: @page_size })),
      success: (collection) =>
        content_html = @collectionTemplate(collection: collection)
        @content.html(content_html)

        @resetPagination(collection.products.length, collection.total_products)
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
          @content.find(@showMoreSelector).closest('.row.relative').before(content_html)
          # @updatePagination(collection.products.length, collection.total_products)
          @updatePagination(collection.products.length, collection.total_products)

          if collection && collection.details
            @updateCollectionDetails(collection.details)
      ).always( =>
        @loading = false
      )

  # private methods

  addValue: (object, propertyName, elementSelector) ->
    propertyValue = @filter.find(elementSelector).val()
    object[propertyName] = propertyValue unless _.isEmpty(propertyValue)
    object

  getSelectedValues: () ->
    bodyshapeArray = []
    colourArray = []
    styleArray = []

    if $("#collapse-colors .swatch-all input:not(:checked)")
      colorInputs = $("#collapse-colors [class^='swatch-']:not(.swatch-all) input:checked")
      for colorInput in colorInputs
        colourArray.push($(colorInput).attr("name"))
      colour = $("#other-colors option:selected").attr("name")
      if colour != "none"
        colourArray.push(colour)

    if $("#collapse-bodyshape .swatch-all input:not(:checked)")
      bodyshapeInputs = $("#collapse-bodyshape [class^='swatch-']:not(.swatch-all) input:checked")
      for bodyshapeInput in bodyshapeInputs
        bodyshapeArray.push($(bodyshapeInput).attr("name"))

    if $("#collapse-style .swatch-all input:not(:checked)")
      styleInputs = $("#collapse-style [class^='swatch-']:not(.swatch-all) input:checked")
      for styleInput in styleInputs
        styleArray.push($(styleInput).attr("name"))

    filter =  {
      bodyshape: bodyshapeArray,
      colour: colourArray,
      style: styleArray,
      order: @productOrderInput.val()
      q:         getUrlParameter("q")?.replace(/\+/g," ")
    }

    priceHash = {}

    if $(".selector-price input:checked").data("all") == false
      priceMin = $(".selector-price input:checked").data("pricemin")
      priceMax = $(".selector-price input:checked").data("pricemax")
      priceHash["priceMin"] = priceMin
      priceHash["priceMax"] = priceMax if priceMax?
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
