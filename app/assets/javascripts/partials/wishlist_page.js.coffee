$('.wishlists_items').ready ->
  updateContentHandlers = () ->
    # bind quick view
    $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
    $("a[data-action='add-to-wishlist']").on('click', window.productWishlist.onClickHandler)

  window.helpers.quickViewer.init()
  updateContentHandlers()
