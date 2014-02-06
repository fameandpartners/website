$('.recommended_dresses.index').ready ->
  page.enableQuickView($('.recommended_dresses.index'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))
