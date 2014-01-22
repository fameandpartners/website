window.page = {
  enableShoppingCart: () ->
    window.shopping_cart.init(window.bootstrap)

  enableProductVariantsSelector: (parentContainer) ->
    if window.product_variants
      page.variantsSelector = window.helpers.createProductVariantsSelector(parentContainer)
      page.variantsSelector.init(window.product_variants)

  enableQuickView: (quickViewLinks) ->
    window.helpers.quickViewer.init()
    quickViewLinks.on('click', window.helpers.quickViewer.onShowButtonHandler)

  enableWhatSizeIam: (link) ->
    link.fancybox({width: '1000', height: '183'})

  enableBuyButton: (button, options = {}) ->
    window.helpers.addBuyButtonHandlers(button, options)

  enableSendToFriendButton: (buttons) ->
    buttons.on('click', (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data('product')
      popups.showSendToFriendPopup(productId, { analyticsLabel: window.product_analytics_label })
    )

  enableAccordeonBars: (elements) ->
    elements.on('click', (e) ->
      $(e.target).closest('li').toggleClass('opened')
    )

  enableWishlistLinks: (links) ->
    productWishlist.addWishlistButtonActions(links)
}
