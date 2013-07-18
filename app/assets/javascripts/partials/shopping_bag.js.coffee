$ ->
  window.shopping_cart.init(window.bootstrap)

  window.shoppingBag = {
    container: null
    cartTemplate: JST['templates/shopping_cart']
    carouselEnabled: false
    init: () ->
      window.shoppingBag.container = $('.first-level .shopping-bag')

      shoppingBag.updateElementsHandlers()
      #shoppingBag.updateCarousel()
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
      if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
        shoppingBag.hide()
      else
        shoppingBag.show()

    show: () ->
      if !shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow", () ->
          shoppingBag.updateCarousel() if !shoppingBag.carouselEnabled
        )
      window.shoppingBag

    hide: () ->
      if shoppingBag.container.find("#shopping-bag-popup-wrapper").is(":visible")
        shoppingBag.container.find("#shopping-bag-popup-wrapper").slideToggle("slow")
      window.shoppingBag

    renderCart: (e, data) ->
      cartHtml = shoppingBag.cartTemplate
        order: data.cart
        csrf_param: $('[name="csrf-param"]').attr('content')
        csrf_token: $('[name="csrf-token"]').attr('content')

      shoppingBag.container.find('#shopping-bag-popup-wrapper').replaceWith(cartHtml)
      #shoppingBag.show()
      # update actions
      shoppingBag.updateElementsHandlers()
      shoppingBag.carouselEnabled = false
      shoppingBag.updateCarousel(data.id)
      item_count = _.reduce(data.cart.line_items, ((memo, item) -> memo += item.quantity), 0)
      $('a.shopping-bag-toggler .counter').html(item_count)

    updateElementsHandlers: () ->
      shoppingBag.container.find('.remove-item-from-cart')
        .off('click', shoppingBag.removeProductClickHandler)
        .on('click', shoppingBag.removeProductClickHandler)

    updateCarousel: (variantId) ->
      return unless $("#shopping-bag-popup").is(":visible")

      start = $('#shopping-bag-popup').first().find(' > li')
        .index($("li:has(a.remove-item-from-cart[data-id='#{variantId}'])"))
      start = 0 if start < 0 # -1 : not found

      options = window.helpers.get_vertical_carousel_options({
        items: 2, start: start,
        prev: { button: "#shopping-arrow-up", items: 2 },
        next: { button: "#shopping-arrow-down", items: 2 }
      })
      $("#shopping-bag-popup").carouFredSel(options)
      $("#shopping-bag-popup").trigger('slideTo', start)
      shoppingBag.carouselEnabled = true
  }

  shoppingBag.init()
