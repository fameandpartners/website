#= require 'templates/product_collection'

window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']

  constructor: (filter, content) ->
    @filter = $(filter)
    @content = $(content)

    @styleInput         = new inputs.ProductStyleNameSelector(container: @filter.find('#style'))
    @bodyShapeInput     = new inputs.ProductBodyShapeSelector(container: @filter.find('#bodyshape'))
    @colorInput         = new inputs.ProductColorNameSelector(container: @filter.find('#color'))
    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @styleInput.on('change', @update)
    @bodyShapeInput.on('change', @update)
    @colorInput.on('change', @update)
    @productOrderInput.on('change', @update)

    # $('.disable-input .selectize-input input').prop('disabled', true).css('pointer-events', 'none');
  update: () =>
    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    $.ajax(urlWithSitePrefix('/dresses'),
      type: "GET",
      dataType: 'json',
      data: $.param(updateRequestParams)
      success: (data) =>
        content_html = @collectionTemplate(products: data.products)
        @content.html(content_html)

        track.pageView(pageUrl, updateRequestParams)

        #productsFilter.$el.find('.category-catalog.products-list').replaceWith(data.products_html)
        #header = productsFilter.$el.find('.category-header')
        #header.find('h1').html(data.page_info.banner_title)
        #header.find('h2').html(data.page_info.banner_text)
        #productsFilter.updateContentHandlers()
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
