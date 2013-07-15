$('.wishlists_items').ready ->
  updateContentHandlers = () ->
    # bind quick view
    $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
    productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))

  window.helpers.quickViewer.init()
  updateContentHandlers()
