$('.users_wishlists_items').ready ->
  wishlistPage = {
    editPopup: null

    init: () ->
      wishlistPage.container = $('#wishlists_items')
      wishlistPage.updateContentHandlers()
      wishlistPage.editPopup = window.helpers.createVariantsSelectorPopup()
      wishlistPage.container.append(wishlistPage.editPopup.init())

    updateContentHandlers: () ->
      productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
      window.initHoverableProductImages()
      $('.add-to-cart.master').on('click', wishlistPage.moveToCartClickHander)
      window.shoppingBag.afterUpdateCallback(window.shoppingBag.showTemporarily)

    moveToCartClickHander: (e) ->
      e.preventDefault()
      variant_id = $(e.currentTarget).data('variant')
      item_id = $(e.currentTarget).data('item')
      quantity = $(e.currentTarget).data('quantity')
      wishlistPage.editPopup.show({ variant_id: variant_id, quantity: quantity }, { id: item_id })
      wishlistPage.editPopup.one('selected', (e, data) ->
        itemId = data.params.id
        $.ajax(
          url: urlWithSitePrefix("/wishlists_items/#{itemId}/move_to_cart"),
          dataType: 'script',
          data: data
        )
      )
  }

  wishlistPage.init()
