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

  updateData: (data) =>
    @loaded = true
    @data = data
    @trigger('change')

  # request to force data requesting from server
  # if already loaded, do nothing. it should be done by other methods
  load: () ->
    if @isLoaded()
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
    ).success(
      @updateData
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

#_base = undefined
#window.shopping_cart = {}
#window.shopping_cart = _.extend(window.shopping_cart,
#  event_bus: $({})
#  line_items: []
#  order: {}
#  initialized: false
#  init: (bootstrap_data) ->
#    return  unless bootstrap_data?
#    unless window.shopping_cart.initialized
#      window.shopping_cart.order = bootstrap_data.order.cart
#      window.shopping_cart.line_items = _.collect(JSON.parse(bootstrap_data.order.cart.line_items), (object) ->
#        object.line_item
#      )
#      window.shopping_cart.order.line_items = window.shopping_cart.line_items
#    window.shopping_cart.initialized = true
#    # add redirect
#    window.shopping_cart.on('item_added', buildDelayedRedirectToPage('/cart?cf=buybtn', 1000))
#
#  addProduct: (variantId, options) ->
#    options = {}  unless options?
#    unless variantId?
#      options.failure.apply window, arguments  if options.failure?
#      return
#    options = _.extend(
#      variant_id: variantId
#      quantity: 1
#    , options)
#    $.ajax
#      url: urlWithSitePrefix("/line_items")
#      type: "POST"
#      dataType: "json"
#      data: window.shopping_cart.prepareParams(options)
#      success: window.shopping_cart.buildOnSuccessCallback(['item_added'], variantId, options.success)
#      error: window.shopping_cart.buildOnErrorCallback(["item_add_failed"], options.failure)
#
#
#  updateProduct: (itemId, options) ->
#    variantId = undefined
#    options = {}  unless options?
#    variantId = options.variant_id
#    if (not (variantId?)) or not itemId or (not (options.quantity?))
#      options.failure.apply window, arguments  if options.failure?
#      return false
#    $.ajax
#      url: urlWithSitePrefix("/line_items/" + itemId)
#      type: "PUT"
#      dataType: "json"
#      data: window.shopping_cart.prepareParams(options)
#      success: window.shopping_cart.buildOnSuccessCallback(["item_changed"], itemId, options.success)
#      error: window.shopping_cart.buildOnErrorCallback(["item_change_failed"], variantId, options.failure)
#
#
#  moveLineItemToWishlist: (item_id, options) ->
#    options = {}  unless options?
#    unless item_id?
#      options.failure.apply window, arguments  if options.failure?
#      return false
#    $.ajax
#      url: urlWithSitePrefix("/line_items/" + item_id + "/move_to_wishlist")
#      type: "POST"
#      dataType: "json"
#      data: {}
#      success: window.shopping_cart.buildOnSuccessCallback([
#        "item_removed"
#        "moved_to_wishlist"
#      ], item_id, options.success)
#      error: window.shopping_cart.buildOnErrorCallback([
#        "item_remove_failed"
#        "moving_to_wishlist_failed"
#      ], item_id, options.failure)
#
#
#  removeProduct: (variantId, options) ->
#    options = {}  unless options?
#    unless variantId?
#      options.failure.apply window, arguments  if options.failure?
#      return false
#    options = _.extend(
#      variant_id: variantId
#    , options)
#    $.ajax
#      url: urlWithSitePrefix("/line_items/" + variantId)
#      type: "DELETE"
#      dataType: "json"
#      data: window.shopping_cart.prepareParams(options)
#      success: window.shopping_cart.buildOnSuccessCallback(["item_removed"], variantId)
#      error: window.shopping_cart.buildOnErrorCallback(["item_remove_failed"], variantId, options.failure)
#
#
#  prepareParams: (options) ->
#    data = undefined
#    key = undefined
#    options = {}  unless options?
#    data = {}
#    for key of options
#      data[key] = options[key]  unless _.isFunction(options[key])
#    $.param data
#
##  buildOnSuccess: ->
##    console.log("Cart: Added to Cart.")
##
##    _.delay ( ->
##      window.location.href = "/cart?cf=buybtn"
##      return
##    ), 1000
##
##
#
#  buildOnSuccessCallback: (event_names, objectId, successCallback) ->
#    func = undefined
#    func = (response) ->
#      data = undefined
#      data = window.shopping_cart.parseResponse(response)
#      window.shopping_cart.order = data.order
#      window.shopping_cart.line_items = data.order.line_items
#      successCallback.apply window, arguments  if successCallback?
#      _.each event_names, (event_name) ->
#        window.shopping_cart.trigger event_name,
#          cart: data.order
#          id: objectId
#
#
#
#    func
#
#  buildOnErrorCallback: (event_name, objectId, failureCallback) ->
#    console.log("Cart: Add to Cart Failed.")
#    func = undefined
#    func = (response) ->
#      failureCallback.apply window, arguments  if failureCallback?
#      window.shopping_cart.trigger event_name,
#        response: response
#        id: objectId
#
#
#    func
#
#  parseResponse: (response) ->
#    data = undefined
#    responseText = undefined
#    result = undefined
#    result = {}
#    responseText = response.responseText or response
#    data = parseIfString(responseText)
#    if data?
#      result.order = JSON.parse(data.order).cart
#      result.order.line_items = _.collect(JSON.parse(result.order.line_items), (item) ->
#        item.line_item
#      )
#    result
#)
#(_base = window.shopping_cart).event_bus or (_base.event_bus = $({}))
#window.shopping_cart.on = delegateTo(window.shopping_cart.event_bus, "on")
#window.shopping_cart.off = delegateTo(window.shopping_cart.event_bus, "off")
#window.shopping_cart.trigger = delegateTo(window.shopping_cart.event_bus, "trigger")
