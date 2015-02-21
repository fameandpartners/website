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

    # possible, we should wrap to some inputs/base object
    _.each(@filter.find('#style, #bodyshape, #color, #product_order'), (el) =>
      new SelectFx(el, onChange: @update)
    )

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
    result = {}
    @addValue(result, 'bodyshape', '#bodyshape')
    @addValue(result, 'colour', '#color')
    @addValue(result, 'style', '#style')
    @addValue(result, 'order', '#product_order')
    result

  updatePageLocation: (filter) ->
    url = '/dresses'
    if _.isEmpty(filter)
      url = '/dresses'
    else
      url = "/dresses?#{ $.param(filter) }"

    url = urlWithSitePrefix(url)
    window.history.pushState({ path: url }, '', url)
    url
