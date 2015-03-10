#= require 'templates/_product'
#= require 'templates/product_collection'

window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']

  constructor: (options = {}) ->
    @details_elements = options.details_elements || {}
    @filter = $(options.controls)
    @content = $(options.content)

    @styleInput         = new inputs.ProductStyleNameSelector(container: @filter.find('#style'))
    @bodyShapeInput     = new inputs.ProductBodyShapeSelector(container: @filter.find('#bodyshape'))
    @colorInput         = new inputs.ProductColorNameSelector(container: @filter.find('#color'))
    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @styleInput.on('change', @update)
    @bodyShapeInput.on('change', @update)
    @colorInput.on('change', @update)
    @productOrderInput.on('change', @update)

    @hoverize()

    # $('.disable-input .selectize-input input').prop('disabled', true).css('pointer-events', 'none');
  update: () =>
    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    $.ajax(urlWithSitePrefix('/dresses'),
      type: "GET",
      dataType: 'json',
      data: $.param(updateRequestParams)
      success: (collection) =>
        content_html = @collectionTemplate(collection: collection)
        @content.html(content_html)

        @hoverize()

        if collection && collection.details
          @updateCollectionDetails(collection.details)

        track.pageView(pageUrl, updateRequestParams)
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
