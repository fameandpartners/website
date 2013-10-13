window.helpers or= {}

window.helpers.addBuyPersonalizedButtonHandlers = (addButton, args = {}) ->
  $button = $(addButton)
  options = args

  # clear
  $button.off('click')
  $button.off('variant_selected')

  # add product to cart
  $button.on('click', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    button = $(e.currentTarget)
    variantId = button.data('id')
    if variantId?
      button.addClass('adding')
      window.shopping_cart.addProduct.call(window.shopping_cart, variantId, {
        failure: () -> button.removeClass('adding')
        success: (data) ->
          button.removeClass('adding').addClass('added')
          track.addedToCart(data.analytics_label) if data.analytics_label?
      })

      if options.expandShoppingBag
        window.shoppingBag.afterUpdateCallback(window.shoppingBag.showTemporarily)
    else
      window.helpers.showErrors($(e.currentTarget).parent(), 'Please, select size and colour')
  )

  $button.on('variant_selected', (e) ->
    window.helpers.showErrors($(e.currentTarget).parent())
  )
