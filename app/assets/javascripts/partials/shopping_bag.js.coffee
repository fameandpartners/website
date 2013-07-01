$ ->
  window.shopping_cart.init(window.bootstrap)

  shoppingBag = {
    cartTemplate: JST['templates/shopping_cart']
    init: () ->
      shoppingBag.updateElementsHandlers()
      shoppingBag.updateCarousel()
      $("#shopping-bag-popup-wrapper").hide()
      $(".shopping-bag-toggler").on('click', shoppingBag.toggleVisibilityClickHandler)

      window.shopping_cart.on('item_added',   shoppingBag.renderCart)
      window.shopping_cart.on('item_changed', shoppingBag.renderCart)
      window.shopping_cart.on('item_removed', shoppingBag.renderCart)

    removeProductClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      window.shopping_cart.removeProduct(variantId)

    toggleVisibilityClickHandler: (e) ->
      e.preventDefault()
      $("#shopping-bag-popup-wrapper").slideToggle("slow")

    renderCart: (e, cart) ->
      cartHtml = shoppingBag.cartTemplate(order: cart)
      $('#shopping-bag-popup-wrapper').replaceWith(cartHtml)
      # update actions
      shoppingBag.updateElementsHandlers()
      shoppingBag.updateCarousel()

    updateElementsHandlers: () ->
      $('.remove-item-from-cart')
        .off('click', shoppingBag.removeProductClickHandler)
        .on('click', shoppingBag.removeProductClickHandler)

    updateCarousel: () ->
      options = window.helpers.get_vertical_carousel_options({
        items: 2,
        prev: { button: "#shopping-arrow-up", items: 2 },
        next: { button: "#shopping-arrow-down", items: 2 }
      })
      $("#shopping-bag-popup").carouFredSel(options)
  }

  shoppingBag.init()
