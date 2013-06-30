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
      window.shopping_cart.onSuccessCallback(window.shopping_cart, event_name, response)
    return func

  onSuccessCallback: (event_name, response) ->
    data = JSON.parse(response.responseText)
    @line_items = data.line_items
    @order      = data.order
    @event_bus.trigger(event_name, data.order, data.line_items)

  onFailCallback: () ->
    console.log('failed request', arguments)
})

window.shopping_cart.event_bus or= $({})

window.delegateTo = (object, method_name) ->
  func = () ->
    object[method_name].apply(object, arguments)
  return func

# pub/sub actions delegate
#window.shopping_cart.on       = delegateTo(window.shopping_cart.event_bus, 'on')
#window.shopping_cart.off      = delegateTo(window.shopping_cart.event_bus, 'off')
#window.shopping_cart.trigger  = delegateTo(window.shopping_cart.event_bus, 'trigger')

###
# usage
window.shopping_cart.event_bus.trigger('item_added')
window.shopping_cart.event_bus.trigger('item_removed')
window.shopping_cart.event_bus.trigger('item_changed')

window.shopping_cart.event_bus.on("item_added", (cart, *[other_args]) ->
  # run callbacks
###
