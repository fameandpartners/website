$('.wishlists_items').ready ->
  page = {
    editPopup: null

    init: () ->
      page.container = $('#wishlists_items')

      window.helpers.quickViewer.init()
      page.updateContentHandlers()

      page.editPopup = window.helpers.createVariantsSelectorPopup()
      page.container.append(page.editPopup.init())

    updateContentHandlers: () ->
      # bind quick view
      $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
      productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
      window.initHoverableProductImages()

      $('.add-to-cart.master').on('click', page.moveToCartClickHander)

      window.shoppingBag.afterUpdateCallback(window.shoppingBag.showTemporarily)

    moveToCartClickHander: (e) ->
      e.preventDefault()
      variant_id = $(e.currentTarget).data('variant')
      item_id = $(e.currentTarget).data('item')
      quantity = $(e.currentTarget).data('quantity')
      page.editPopup.show({ variant_id: variant_id, quantity: quantity }, { id: item_id })
      page.editPopup.one('selected', (e, data) ->
        itemId = data.params.id
        $.ajax(
          url: "/wishlists_items/#{itemId}/move_to_cart",
          dataType: 'script',
          data: data
        )
      )
  }

  page.init()
