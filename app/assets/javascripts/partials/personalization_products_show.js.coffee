$(".personalization_products.show").ready ->
  # common
  page.enableShoppingCart()

  # products_info partial
  page.enableWhatSizeIam($('.toggle-sizes'))
  page.enableAccordeonBars($('ul.slider > li:not(.recommended)'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))

  # header - nav partial
  page.enableSendToFriendButton($('a.send-to-friend'))

  # personalization
  formContainer = $('#content .product-page')
  page.enablePersonalisatonForm(formContainer)

  image = formContainer.find('.grid-6.product-image img')
  formContainer.on('selection_changed', (e, selected) ->
    return if _.isEmpty(window.productImagesData)
    image_data = _.findWhere(window.productImagesData, (color: selected.color))
    image_data or= _.findWhere(window.productImagesData, (color: window.product_default_color))
    image.attr('src', image_data.large) if image_data
    return
  )
