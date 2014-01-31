$(".personalization_products.style").ready ->
  window.shopping_cart.init(window.bootstrap)

  if window.product_variants
    variantsSelector = window.helpers.createProductVariantsSelector($('#content .product-info'))
    variantsSelector.init(window.product_variants)

  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  window.helpers.addBuyButtonHandlers($('.buy-now'), { expandShoppingBag: true})

  # send to friend
  $('a.send-to-friend').on('click', (e) ->
    e.preventDefault()
    productId = $(e.currentTarget).data('product')
    popups.showSendToFriendPopup(productId, { analyticsLabel: window.product_analytics_label })
  )

  # toggle accordeon bars on right
  $('ul.slider li').on('click', (e) ->
    $(e.target).closest('li').toggleClass('opened')
  )
