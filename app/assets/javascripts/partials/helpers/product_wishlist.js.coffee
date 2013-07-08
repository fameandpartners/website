  productWishlist = {
    onClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data("id")
      productWishlist.addProduct.call(productWishlist, variantId)

    addProduct: (variantId, options = {}) ->
      return unless variantId?
      options = _.extend({ variant_id: variantId }, options)
      $.ajax(
        url: "/wishlists_items"
        type: 'POST'
        dataType: 'json'
        data: $.param(options)
        success: productWishlist.successCallback
      )

    successCallback: (data) ->
      console.log('successCallback add to wishlist')
  }
  window.productWishlist = productWishlist
