# actually, shopping cart is  model, not view
# new ShoppingCart({ bootstrap or nil })
#
window.helpers or= {}
window.helpers.ShoppingCart = class ShoppingCart
  constructor: (options = {}) ->
    @$eventBus = $({})
    # code
    @data    = { item_count: 0, products: [] }
    @loaded   = false

    @trigger =  delegateTo(@$eventBus, 'trigger')
    @on      =  delegateTo(@$eventBus, 'on')
    @one     =  delegateTo(@$eventBus, 'one')

  setItemCount: (item_count) =>
    return if @loaded
    @data.item_count = item_count
    @trigger('change')

  updateData: (data) =>
    @loaded = true
    @data = data
    @trigger('change')

  # request to force data requesting from server
  # if already loaded, do nothing. it should be done by other methods
  load: (force = false) ->
    if @isLoaded() && !force
      @trigger('load')
    else
      @loaded = true
      $.ajax(
        url: urlWithSitePrefix("/user_cart/details")
        type: "GET"
        dataType: "json"
      ).success((data) =>
        @updateData(data)
        @trigger('load')
      ).error( () =>
        @loaded = false
      )

  isLoaded: () ->
    !!@loaded

  data: () ->
    @data

  # options:
  #   variant_id
  #   size_id
  #   color_id
  #   customizations_ids
  addProduct: (product_data = {}) ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/products")
      type: "POST"
      dataType: "json"
      data: product_data
    ).success((data) =>
      @updateData(data)
      added_product = _.find((data.products || []), (product) ->
        product.variant_id == product_data.variant_id
      )
      @trackAddToCart(added_product)
    ).error( () =>
      @trigger('error')
    )

  updateProduct: (line_item_id, options = {}) ->
    console.log('updateProduct', options)

  removeProduct: (line_item_id) ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/products/#{ line_item_id }")
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  removeProductCustomization: (line_item_id, customization_id) ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/products/#{ line_item_id }/customizations/#{ customization_id }")
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  removeProductMakingOption: (line_item_id, making_option_id) ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/products/#{ line_item_id }/making_options/#{ making_option_id }")
      type: "DELETE"
      dataType: "json"
    ).success(
      @updateData
    ).error( () =>
      @trigger('error')
    )

  # apply code
  # note - error messages placed here, if something changed - move this upper in logic
  applyPromotionCode: (code) ->
    $.ajax(
      url: urlWithSitePrefix("/user_cart/promotion"),
      type: 'POST',
      dataType: "json",
      data: { promotion_code: code }
    ).success((data) =>
      if data.error
        @trigger('error', data)
        @trigger('complete', data)
        window.helpers.showAlert(message: data.error)
      else
        @updateData(data)
        @trigger('success', data)
        @trigger('complete', data)
        window.helpers.showAlert( type: 'success', title: 'Success!', message: 'You are one step closer to being a fame babe')
    ).error( () =>
      @trigger('error')
    )

  # analytics
  trackAddToCart: (product) ->
    try
      window._fbq ||= []
      window._fbq.push(['track', '6021815151134', {
        'value': product.price.amount,
        'currency':product.price.currency
      }])
    catch
      # do nothing
