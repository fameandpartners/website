$(".personalization_products.style").ready ->
  # common
  page.enableShoppingCart()

  # products_info partial
  variantsSelectorContainer = $('#content .product-info')
  page.enableProductVariantsSelector(variantsSelectorContainer)

  page.enableWhatSizeIam($('.toggle-sizes'))
  page.enableBuyButton($('#content .buy-now'), { expandShoppingBag: true})
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

  page.enableTwinAlertButton($('.twin-alert a.twin-alert-link'), () ->
    selected = variantsSelectorContainer.data('selected')
    if _.isUndefined(selected) || _.isNull(selected.color)
      return null
    else
      return selected.color
  )

  # Show customisation options

  $('.trigger-customisation-selector').on "click", ->
    $(this).toggleClass "active"
    $('.customisation-selector').toggle()
