window.helpers or= {}

window.helpers.addBuyButtonHandlers = (addButton, args = {}) ->
  $button = $(addButton)
  options = args

  # clear
  $button.off('click')
  $button.off('variant_selected')

  # helper methods
  addErrorMessage = (container, messageText) ->
    return true # error message markup required
    block = container.find('.error.message')
    if block.length == 0
      container.append($("<span class='error message' style='display: none;'></span>"))
      block = container.find('.error.message')
    block.text(messageText).fadeIn()
    setTimeout( () ->
      hideErrorMessage(container)
    , 3000)

  hideErrorMessage = (container) ->
    container.find('.error.message').fadeOut('slow')

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
        success: () -> button.removeClass('adding').addClass('added')
      })

      if options.expandShoppingBag
        window.shoppingBag.afterUpdateCallback(window.shoppingBag.showTemporarily)
    else
      addErrorMessage($(e.currentTarget).parent(), 'Please, select size and color')
  )

  $button.on('variant_selected', (e) ->
    hideErrorMessage($(e.currentTarget).parent())
  )
