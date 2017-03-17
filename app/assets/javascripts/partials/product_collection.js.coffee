#= require 'templates/_product'
#= require 'templates/product_collection'
#= require 'templates/product_collection_append'

window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null,
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']
  collectionMoreTemplate: JST['templates/product_collection_append']

  constructor: (options = {}) ->
    options = $.extend({
      reset_source: true,
      page_size: 21,
      mobileBreakpoint: 768,
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

    @mobileBreakpoint = options.mobileBreakpoint

    # pagination
    @page_size = options.page_size
    @showMoreSelector = options.showMoreSelector
    @resetPagination(options.size, options.total_products)
    @content.on('click', @showMoreSelector, @showMoreProductsClickHandler)
    $(window).on('scroll', @scrollHandler)

    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @setUpFilterElements()
    @productOrderInput.on('change', @update)
    @$banner = $(options.banner)

  setUpFilterElements: =>
    $(".search-filters :input").on 'change', (e) =>
      @updateFilterElements(e)

    $(".js-trigger-clear-all-filters").on('click', @clearAllOptions)

    # toggle mobile version of filter menu
    $('.js-trigger-toggle-filters').on 'click', (e) =>
      $('body').toggleClass('filter-is-active no-scroll');
      $('.js-side-panel-filters').toggleClass('is-active');

    # enable content scroll for larger tablets if orientation changed
    $(window).on 'resize', (e) =>
      if $(window).width() >= @mobileBreakpoint && $('body').hasClass('filter-is-active')
        $('body').removeClass('no-scroll');
      if $(window).width() < @mobileBreakpoint && $('body').hasClass('filter-is-active')
        $('body').addClass('no-scroll');

  updateFilterElements: (e) =>
    $this = $(e.target)
    if $this.parents('.panel-collapse').find('input:checked').length == 0
      $this.parents('.panel-collapse').find('.js-filter-all').prop('checked', true)
    else
      if !$this.hasClass('js-filter-all')
        $this.parents('.panel-collapse').find('.js-filter-all').removeAttr("checked")
      else
        $this.parents('.panel-collapse').find('input').prop('checked', false)
        $this.parents('.panel-collapse').find('.js-filter-all').prop('checked', true)
        $this.parents('.panel-collapse').find("select option:selected").prop("selected", false)
        $this.parents('.panel-collapse').find("select option:first").prop("selected", "selected")

    @update()

  clearAllOptions: =>
    $('#filter-accordion :input').prop('checked', false)
    $('#filter-accordion .js-filter-all').prop('checked', true)
    $('#filter-accordion select').val('none')
    $('#filter-accordion .panel-collapse').collapse('hide')
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
          @content.find(@showMoreSelector).closest('.more-products').before(content_html)
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
      color_group: colorArray,
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
