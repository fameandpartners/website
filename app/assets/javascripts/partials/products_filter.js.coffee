$(".products").ready ->
  productsFilter = {
    toggleFilterOptionClicked: (e) ->
      e.preventDefault()
      $container = $(e.currentTarget).closest('li')
      $container.toggleClass('active')

      $input = $container.find('input')
      $input.prop('checked', $container.is('.active'))

      if $input.val() == 'all'
        if $container.is('.active')
          $container.siblings().addClass('active')
          $container.find('input').prop('checked', true)
        else
          $container.siblings().removeClass('active')
          $container.find('input').prop('checked', false)

      productsFilter.searchProducts.call(productsFilter)

    toggleColorClicked: (e) ->
      e.preventDefault()
      $target = $(e.currentTarget)
      $target.toggleClass('active')

      if $target.data('color') == 'all'
        if $target.is('.active')
          $target.siblings().addClass('active')
        else
          $target.siblings().removeClass('active')
      productsFilter.searchProducts.call(productsFilter)

    currentFilter: () ->
      filter = {
        taxons: { range: [], style: [] }
        colors: []
        order: $('#product_order').val()
      }

      get_value_func = (obj) -> $(obj).val()
      filter.taxons.range = _.collect($('ul.filters-boxes.range li input:checked'), get_value_func)
      filter.taxons.style = _.collect($('ul.filters-boxes.style li input:checked'), get_value_func)
      filter.colors = _.collect($('.filters-block .colors .color.active'), (obj) ->
        $(obj).data('color')
      )
      return filter

    updatePageLocation: (filter) ->
      url = "#{ window.location.pathname }?#{ $.param(filter) }"
      window.history.pushState({path:url},'',url)

    searchProducts: () ->
      searchData = @currentFilter()
      @updatePageLocation(searchData)

      $.ajax('/products',
        type: "GET",
        dataType: 'html',
        data: $.param(searchData)
        success: (html) ->
          $('.grid-75.fright').html(html)
      )
  }

  $('.filters-block .filters-boxes li label').on('click', productsFilter.toggleFilterOptionClicked)
  $('.filters-block .color').on('click', productsFilter.toggleColorClicked)
