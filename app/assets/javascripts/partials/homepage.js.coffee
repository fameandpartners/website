$(".index.show").ready ->
  # enable products scroll
  $("#product-items").carouFredSel(window.helpers.get_horizontal_carousel_options())

  # add quick view feature
  window.helpers.quickViewer.init()

  $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
  $("a[data-action='add-to-wishlist']").on('click', window.productWishlist.onClickHandler)
