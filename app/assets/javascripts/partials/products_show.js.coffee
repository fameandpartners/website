$(".products.show").ready ->
  window.shopping_cart.init(window.bootstrap)

  # enable product main tabs
  window.helpers.enableTabs($('.tabs'))

  # carousel for similar or related products
  carousel = $("#product-items").carouFredSel(
    window.helpers.get_horizontal_carousel_options()
  )
  # enable images carousel
  $("#product-images").carouFredSel(
    window.helpers.get_vertical_carousel_options(
      width: 83
      height: 528
      items:
        start: 0
        visible: 4
        height: 132
      scroll:
        items: 1
    )
  )

  # show big images from carouseled small images
  viewer = null
  setTimeout ()->
      viewer = window.helpers.buildImagesViewer($('#content .wrap')).init()
    , 1000

  # enable color-size combination selection
  if window.product_variants
    variantsSelector = window.helpers.createProductVariantsSelector($('#content .wrap'))
    variantsSelector.init(window.product_variants)

  # add quick view feature
  window.helpers.quickViewer.init()
  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)

  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  window.initHoverableProductImages()

  # what size i'm
  $('.toggle-sizes').fancybox({width: '1000', height: '183'})

  window.helpers.addBuyButtonHandlers($('.buy-wishlist .buy-now'), { expandShoppingBag: true})

  $(".tabs .tabs-links a[href='#videos']").on('click', (e) ->
    if !_.isEmpty(window.product_analytics_label)
      track.viewVideo(window.product_analytics_label)
  )

  $(".tabs .tabs-links a[href='#inspiration']").on('click', (e) ->
    if !_.isEmpty(window.product_analytics_label)
      track.viewCelebrityInspiration(window.product_analytics_label)
  )

  # send to friend
  $('a.send-to-friend').on('click', (e) ->
    e.preventDefault()
    product = $(e.currentTarget).data('product')
    popups.showSendToFriendPopup(product)
  )
