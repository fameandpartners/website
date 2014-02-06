$('.pages.my_boutique').ready ->
  page.enableQuickView($('.pages.my_boutique'))
  page.enableWishlistLinks($("a[data-action='add-to-wishlist']"))
