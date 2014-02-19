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
