$(".products").ready ->
  productsFilter = {
    onClickHandler: (e) ->
      e.preventDefault()
      data = $(e.currentTarget).data()
      productsFilter.updateFilters(data)

    updateFilters: (data) ->
      console.log('searched by', data.taxonomy, data.id)
  }

  $(".filters li a[data-hook='taxon-filter']").on('click', productsFilter.onClickHandler)
