window.ShoppingCartSummary = class ShoppingCartSummary
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_summary']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '#cart')

    _.bindAll(@, 'render', 'removeProductHandler', 'couponFormSubmitHandler')

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', '.promotion-apply', @couponFormSubmitHandler)
    @cart.on('change', @render)
    @

  render: () ->
    @$container.html(@template(cart: @cart.data))

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).data('id')
    @cart.removeProduct(line_item_id)

  couponFormSubmitHandler: () ->
    code = @$container.find('#promotion-code').val()
    @cart.applyPromotionCode(code)
