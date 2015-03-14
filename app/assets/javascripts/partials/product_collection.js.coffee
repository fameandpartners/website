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
    @details_elements = options.details_elements || {}
    @filter = $(options.controls)
    @content = $(options.content)

    # base
    # if users comes by url with specific params, like /dresses/for/very/special/case
    # then use this path until user selects another collection 
    @source_path = window.location.pathname || '/dresses'
    
    # pagination
    @page_size = options.page_size || 20
    @resetPagination(options.size, options.total_products)
    @showMoreSelector = "*[data-action=show-more-collection-products]"
    @content.on('click', @showMoreSelector, @showMoreProductsClickHandler)

    @styleInput         = new inputs.ProductStyleNameSelector(container: @filter.find('#style'))
    @bodyShapeInput     = new inputs.ProductBodyShapeSelector(container: @filter.find('#bodyshape'))
    @colorInput         = new inputs.ProductColorNameSelector(container: @filter.find('#color'))
    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @styleInput.on('change', @update)
    @bodyShapeInput.on('change', @update)
    @colorInput.on('change', @update)
    @productOrderInput.on('change', @update)

    @hoverize()

  resetPagination: (items_on_page, total_records) ->
    @products_on_page = items_on_page
    @total            = total_records
    if @products_on_page <= @total
      @content.find(@showMoreSelector).show()
    else
      @content.find(@showMoreSelector).hide()

  updatePagination: (items_added, total_records) ->
    @products_on_page += items_added
    @total            = total_records
    if @products_on_page <= @total
      @content.find(@showMoreSelector).show()
    else
      @content.find(@showMoreSelector).hide()

  update: () =>
    @source_path = '/dresses'
    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    $.ajax(urlWithSitePrefix(@source_path),
      type: "GET",
      dataType: 'json',
      data: $.param(_.extend(updateRequestParams, { limit: @page_size })),
      success: (collection) =>
        content_html = @collectionTemplate(collection: collection)
        @content.html(content_html)

        @resetPagination(collection.products.length, collection.total_products)

        @hoverize()

        if collection && collection.details
          @updateCollectionDetails(collection.details)

        track.pageView(pageUrl, updateRequestParams)
    )

  showMoreProductsClickHandler: (e) =>
    e.preventDefault()

    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())

    $.ajax(urlWithSitePrefix(@source_path),
      type: "GET",
      dataType: 'json',
      data: $.param(_.extend(updateRequestParams, { limit: @page_size, offset: @products_on_page })),
      success: (collection) =>
        content_html = @collectionMoreTemplate(collection: collection)
        @content.find(@showMoreSelector).before(content_html)
        @updatePagination(collection.products.length, collection.total_products)

        @hoverize()

        if collection && collection.details
          @updateCollectionDetails(collection.details)
    )

  # private methods

  addValue: (object, propertyName, elementSelector) ->
    propertyValue = @filter.find(elementSelector).val()
    object[propertyName] = propertyValue unless _.isEmpty(propertyValue)
    object

  getSelectedValues: () ->
    {
      bodyshape: @bodyShapeInput.val(),
      colour: @colorInput.val(),
      style: @styleInput.val(),
      order: @productOrderInput.val()
    }

  updatePageLocation: (filter) ->
    url = '/dresses'
    filter = _.compactObject(filter || {})
    if _.isEmpty(filter)
      url = '/dresses'
    else
      url = "/dresses?#{ $.param(filter) }"

    url = urlWithSitePrefix(url)
    window.history.pushState({ path: url }, '', url)
    url

  hoverize: ->
    initProductCollectionImageHover(
      selector: '.category--item'
      delegate: '.img-product'
    )

  updateCollectionDetails: (details) =>
    return if !@details_elements
    return if !details

    $('title').html(details.title) if details.title
    $('meta[name=description]').attr('content', details.description) if details.description

    if @details_elements.banner && details.banner
      $(@details_elements.banner.title).html(details.banner.title) if details.banner.title
      $(@details_elements.banner.description).html(details.banner.description) if details.banner.description

      if details.banner.image
        $banner_img = $(@details_elements.banner.image)
        image = new Image()
        image.onload = () -> $banner_img.css('background-image', "url('#{ details.banner.image }')")
        image.src = details.banner.image
