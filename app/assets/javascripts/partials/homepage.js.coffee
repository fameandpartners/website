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

$ ->
  $("#main-promo .slides").carouFredSel(
    window.helpers.get_horizontal_carousel_options(
      infinite: true,
      circular: true,
      auto: 5000,
      width: 1078,
      pagination: '#main-promo .pagination',
      items:
        visible: 1,
        width: 1078,
        height: 532
    )
  )