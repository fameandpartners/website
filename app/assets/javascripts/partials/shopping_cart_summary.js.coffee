#= require templates/shopping_cart_summary
window.ShoppingCartSummary = class ShoppingCartSummary
  constructor: (options = {}) ->
    @template   = JST['templates/shopping_cart_summary']
    @cart       = options.cart # window.shopping_cart
    @$container = $(options.container || '#cart')

    _.bindAll(@, 'render', 'removeProductHandler', 'couponFormSubmitHandler')

    @$container.on('click', '.remove-product', @removeProductHandler)
    @$container.on('click', 'form.promo-code button', @couponFormSubmitHandler)
    @$container.on('submit', 'form.promo-code', @couponFormSubmitHandler)
    @cart.on('change', @render)
    @

  render: () ->
    @$container.html(@template(cart: @cart.data))

  removeProductHandler: (e) ->
    e.preventDefault()
    line_item_id = $(e.currentTarget).data('id')
    @cart.removeProduct(line_item_id)

  couponFormSubmitHandler: (e) ->
    e.preventDefault() if e
    $input = @$container.find('#promotion-code')
    @cart.one('complete', (event, result) -> $input.val(''))
    @cart.applyPromotionCode($input.val())
