window.shopping_cart = {}
window.shopping_cart = _.extend(window.shopping_cart, {
  # jquery object to organize events pub/sub logic
  event_bus: $({})
  line_items: []
  order: {}
  initialized: false

  init: (bootstrap_data) ->
    if !window.shopping_cart.initialized
      window.shopping_cart.order = bootstrap_data.order.cart
      window.shopping_cart.line_items = _.collect(
        JSON.parse(bootstrap_data.order.cart.line_items), (object) -> object.line_item
      )
      window.shopping_cart.order.line_items = window.shopping_cart.line_items
    window.shopping_cart.initialized = true

  addProduct: (variantId, options = {}) ->
    return unless variantId?

    options = _.extend({ variant_id: variantId, quantity: 1 }, options)
    $.ajax(
      url: "/line_items"
      type: 'POST'
      dataType: 'json'
      data: $.param(options)
      complete: window.shopping_cart.buildOnSuccessCallback('item_added')
      failure: window.shopping_cart.onFailCallback
    )

  updateProduct: (variantId, options = {}) ->
    return unless variantId?

    $.ajax(
      url: "/line_items"
      type: 'PUT'
      dataType: 'json'
      data: $.param(options)
      complete: window.shopping_cart.buildOnSuccessCallback('item_updated')
      failure: window.shopping_cart.onFailCallback
    )

  removeProduct: (variantId) ->
    return unless variantId?

    $.ajax(
      url: "/line_items/#{variantId}"
      type: 'DELETE'
      dataType: 'html'
      data: $.param({ variant_id: variantId })
      complete: window.shopping_cart.buildOnSuccessCallback('item_removed')
      failure: window.shopping_cart.onFailCallback
    )

  buildOnSuccessCallback: (event_name) ->
    func = (response) ->
      data = window.shopping_cart.parseResponse(response)
      window.shopping_cart.order = data.order
      window.shopping_cart.line_items = data.order.line_items

      window.shopping_cart.trigger(event_name, data.order)
    return func

  onFailCallback: () ->
    console.log('failed request', arguments)

  parseResponse: (response) ->
    result = {}
    if response?
      data = JSON.parse(response.responseText)
      result.order = JSON.parse(data.order).cart
      result.order.line_items = _.collect(JSON.parse(result.order.line_items), (item) -> item.line_item)

    return result
})

window.delegateTo = (object, method_name) ->
  func = () ->
    object[method_name].apply(object, arguments)
  return func

window.shopping_cart.event_bus or= $({})

# pub/sub actions delegate
window.shopping_cart.on       = delegateTo(window.shopping_cart.event_bus, 'on')
window.shopping_cart.off      = delegateTo(window.shopping_cart.event_bus, 'off')
window.shopping_cart.trigger  = delegateTo(window.shopping_cart.event_bus, 'trigger')
