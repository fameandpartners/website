$(".personalization_products.show").ready ->
  # common
  page.enableShoppingCart()

  # products_info partial
  page.enableWhatSizeIam($('.toggle-sizes'))
  page.enableAccordeonBars($('ul.slider li'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))

  # header - nav partial
  page.enableSendToFriendButton($('a.send-to-friend'))

  # personalization
  page.enablePersonalisatonForm($('#content .product-page'))
