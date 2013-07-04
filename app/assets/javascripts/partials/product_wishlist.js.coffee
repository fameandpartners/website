$(".products, .index.show").ready ->
  productWishlist = {
    onClickHandler: (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      productWishlist.addProduct.call(productWishlist, productId)

    addProduct: (productId) ->
      console.log('invoked add to wishlist for', productId)
  }

  $("a[data-action='add-to-wishlist']").on('click', productWishlist.onClickHandler)
