$(".personalization_products.style").ready ->
  # common
  page.enableShoppingCart()

  # products_info partial
  page.enableProductVariantsSelector($('#content .product-info'))
  page.enableWhatSizeIam($('.toggle-sizes'))
  page.enableBuyButton($('.buy-now'), { expandShoppingBag: true})
  page.enableAccordeonBars($('ul.slider > li:not(.recommended)'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))

  # header - nav partial
  page.enableSendToFriendButton($('a.send-to-friend'))

  $('.book-free-style-session').on('click', (e) ->
    track.clickedBookFreeStylingSession(window.product_analytics_label)
  )
  $('.grid-6 ul.price-list li a').on('click', (e) ->
    track.followedStyleProductLink(window.product_analytics_label)
  )
