$(".personalization_products.show").ready ->
  # common
  page.enableShoppingCart()

  # products_info partial
  #page.enableProductVariantsSelector($('#content .product-info'))
  page.enableWhatSizeIam($('.toggle-sizes'))
  #page.enableBuyButton($('.buy-now'), { expandShoppingBag: true})
  page.enableAccordeonBars($('ul.slider li'))

  # header - nav partial
  page.enableSendToFriendButton($('a.send-to-friend'))

  # personalization
  page.enablePersonalisatonForm($('#content .product-page'))
