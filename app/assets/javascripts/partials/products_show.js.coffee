$(".products.show").ready ->
  window.shopping_cart.init(window.bootstrap)

  # enable product main tabs
  window.helpers.enableTabs($('.tabs'))

  # carousel for similar or related products
  carousel = $("#product-items").carouFredSel(
    window.helpers.get_horizontal_carousel_options(height: 560)
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

  # add product to cart
  $('.buy-wishlist .buy-now').on('click', (e) ->
    e.preventDefault()
    button = $(e.currentTarget)
    variantId = button.data('variant_id')
    button.addClass('adding')
    window.shopping_cart.addProduct.call(window.shopping_cart, variantId, {
      failure: () -> button.removeClass('adding')
      success: () -> button.removeClass('adding').addClass('added')
    })
  )
