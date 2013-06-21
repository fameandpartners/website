$(".products").ready ->
  productsFilter = {
    currentFilter: {}

    onClickHandler: (e) ->
      console.log('onClickHandler')
      e.preventDefault()
      data = $(e.currentTarget).data()
      productsFilter.updateFilters.call(productsFilter, data)

    updateFilters: (data) ->
      if data.filter == 'range'
        @currentFilter.taxons ||= {}
        @currentFilter.taxons.range = data.id
      @applyFilter()

    applyFilter: () ->
      $.ajax(
        '/products',
        data: @currentFilter
        complete: (response) ->
          $('.products-list.grid-container.content').replaceWith(response.responseText)
      )
      @updatePageLocation()

    updatePageLocation: () ->
      console.log(@currentFilter)
      url = "#{ window.location.pathname }?#{ $.param(@currentFilter) }"
      window.history.pushState({path:url},'',url)
  }

  $(".filters li a").on('click', productsFilter.onClickHandler)
