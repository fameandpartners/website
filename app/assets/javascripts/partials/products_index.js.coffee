$(".products.index").ready ->
  # helper method
  get_value_func = (obj) -> $(obj).val()

  productsFilter = {
    init: () ->
      productsFilter.updateContentHandlers()

    changeOrderHandler: (e) ->
      e.preventDefault()
      productsFilter.searchProducts.call(productsFilter)

    toggleFilterOptionClicked: (e) ->
      e.preventDefault()
      $container = $(e.currentTarget).closest('li')
      $container.toggleClass('active')

      $input = $container.find('input')
      $input.prop('checked', $container.is('.active'))

      # if 'all' checked - remove all other
      # if 'all' unchecked - mark all other as setted
      # if 'no all' selected - reset 'all'
      # if 'no all' unselected and no selected elements - select all
      if $input.val() == 'all'
        if $container.is('.active')
          $container.siblings().removeClass('active')
          $container.siblings().find('input').prop('checked', false)
        else
          $container.siblings().addClass('active')
          $container.siblings().find('input').prop('checked', true)
      else
        $all_input = $container.siblings().find('input[value=all]')
        if $container.is('.active')
          $all_input.prop('checked', false).closest('li').removeClass('active')
        else
          if $container.siblings('.active').length == 0
            $container.siblings().find('input[value=all]').prop('checked', true).closest('li').addClass('active')

      productsFilter.searchProducts.call(productsFilter)

    toggleColorClicked: (e) ->
      e.preventDefault()
      $target = $(e.currentTarget)
      $target.toggleClass('active')

      # if 'all' checked - remove all other
      # if 'all' unchecked - mark all other as setted
      # if 'no all' selected - reset 'all'
      # if 'no all' unselected and no selected elements - select all
      if $target.data('color') == 'all'
        if $target.is('.active')
          $target.siblings().removeClass('active')
        else
          $target.siblings().addClass('active')
      else
        if $target.is('.active')
          $target.siblings('.color.all').removeClass('active')
        else
          if $target.siblings('.color.active').length == 0
            $target.siblings('.color.all').addClass('active')

      productsFilter.searchProducts.call(productsFilter)

    getSelectedTaxons: (name, container) ->
      result = {}
      if !container.find('li input[value=all]').is(':checked')
        result[name] = _.collect(container.find('li input:checked'), get_value_func)
      return result

    currentFilter: () ->
      filter = {}

      # taxons
      taxons = {}
      _.extend(taxons, productsFilter.getSelectedTaxons('range', $('ul.filters-boxes.range')))
      _.extend(taxons, productsFilter.getSelectedTaxons('style', $('ul.filters-boxes.style')))
      filter.taxons = taxons unless _.isEmpty(taxons)

      # variants
      container = $('.filters-block .colors')
      if !container.find('.color.all').is('.active')
        choosenColors = _.collect(container.find('.color.active'), (obj) -> $(obj).data('color'))
        filter.colors = choosenColors unless _.isEmpty(choosenColors)

      # body shapes
      selectedShapes = productsFilter.getSelectedTaxons('body_shapes', $('ul.filters-boxes.body_shapes'))
      _.extend(filter, selectedShapes) unless _.isEmpty(selectedShapes)

      # order
      selectedOrder = $('#product_order').val()
      filter.order = selectedOrder unless _.isEmpty(selectedOrder)

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
          productsFilter.updateContentHandlers()
      )

    updateContentHandlers: () ->
      # bind quick view
      $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
      $('#product_order').on('change', productsFilter.changeOrderHandler)

      window.addSwitcherToAltImage() if window.addSwitcherToAltImage
      productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
  }

  window.helpers.quickViewer.init()
  productsFilter.init()

  $('.filters-block .filters-boxes li label').on('click', productsFilter.toggleFilterOptionClicked)
  $('.filters-block .color').on('click', productsFilter.toggleColorClicked)
