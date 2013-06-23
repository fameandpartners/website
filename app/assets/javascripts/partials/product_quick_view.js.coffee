$(".products, .index.show").ready ->
  quickViewer = {
    onClickHandler: (e) ->
      e.preventDefault()
      productId = $(e.currentTarget).data("id")
      quickViewer.showProduct.call(quickViewer, productId)

    showProduct: (productId) ->
      console.log('invoked quick view for', productId)
  }

  $(".quick-view a[data-action='quick-view']").on('click', quickViewer.onClickHandler)
