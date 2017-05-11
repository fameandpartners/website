#= require templates/shopping_cart_delivery_times
window.ShoppingCartDeliveryTimes = class ShoppingCartDeliveryTimes
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_delivery_times']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '.js-shopping_cart_delivery_times')
    console.log('options', options)
    console.log('@template', @template)
    _.bindAll(@, 'render')
    @cart.on('change', @render)

    @render()
    @

  render: () ->
    @$container.html(@template(cart: @cart.data))
