$(".products").ready ->
  quickViewer = {
    onClickHandler: (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      quickViewer.showProduct(productId)

    showProduct: (productId) ->
      console.log('invoked quick view for', productId)
  }

  $(".quick-view a[data-hook='quick-view-link']").on('click', quickViewer.onClickHandler)
