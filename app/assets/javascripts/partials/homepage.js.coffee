$(".index.show").ready ->
  # enable products scroll
  $(".featured#product-items").carouFredSel(
    window.helpers.get_horizontal_carousel_options(
      infinite: true,
      circular: true,
      height: 458
    )
  )

  # add quick view feature
  window.helpers.quickViewer.init()

  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)

  productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
