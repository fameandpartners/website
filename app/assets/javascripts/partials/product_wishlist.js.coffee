$(".products, .index.show").ready ->
  productWishlist = {
    onClickHandler: (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      productWishlist.addProduct.call(productWishlist, productId)

    addProduct: (productId) ->
      console.log('invoked quick view for', productId)
  }

  $(".like a[data-action='add-to-wishlist']").on('click', productWishlist.onClickHandler)
