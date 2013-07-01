$ ->
  window.shopping_cart.init(window.bootstrap)

  window.shoppingBag = {
    container: null
    cartTemplate: JST['templates/shopping_cart']
    init: () ->
      window.shoppingBag.container = $('.first-level .shopping-bag')

      shoppingBag.updateElementsHandlers()
      shoppingBag.updateCarousel()
      shoppingBag.container.find("#shopping-bag-popup-wrapper").hide()
      shoppingBag.container.find(".shopping-bag-toggler").on(
        'click', shoppingBag.toggleVisibilityClickHandler
      )

      window.shopping_cart.on('item_added',   shoppingBag.renderCart)
      window.shopping_cart.on('item_changed', shoppingBag.renderCart)
      window.shopping_cart.on('item_removed', shoppingBag.renderCart)

    removeProductClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data('id')
      window.shopping_cart.removeProduct(variantId)

    toggleVisibilityClickHandler: (e) ->
      e.preventDefault()
      shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow")

    show: () ->
      if !shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow")
      window.shoppingBag

    hide: () ->
      if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow")
      window.shoppingBag

    renderCart: (e, data) ->
      cartHtml = shoppingBag.cartTemplate(order: data.cart)
      shoppingBag.container.find('#shopping-bag-popup-wrapper').replaceWith(cartHtml)
      # update actions
      shoppingBag.updateElementsHandlers()
      shoppingBag.updateCarousel()
      shoppingBag.show()

    updateElementsHandlers: () ->
      shoppingBag.container.find('.remove-item-from-cart')
        .off('click', shoppingBag.removeProductClickHandler)
        .on('click', shoppingBag.removeProductClickHandler)

    updateCarousel: () ->
      options = window.helpers.get_vertical_carousel_options({
        items: 2,
        prev: { button: "#shopping-arrow-up", items: 2 },
        next: { button: "#shopping-arrow-down", items: 2 }
      })
      shoppingBag.container.find("#shopping-bag-popup").carouFredSel(options)
  }

  shoppingBag.init()
