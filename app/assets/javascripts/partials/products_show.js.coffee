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
  viewer = window.helpers.buildImagesViewer($('#content .wrap')).init()

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
