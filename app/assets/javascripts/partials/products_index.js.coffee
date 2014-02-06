$(".spree_products.index").ready ->

  addValue = (object, propertyName, elementSelector) ->
    propertyValue = productsFilter.$el.find(elementSelector).val()
    object[propertyName] = propertyValue unless _.isEmpty(propertyValue)
    object

  productsFilter = {
    $el: null
    init: (el) ->
      @$el = $(el)

      @$el.find('#collection, #style, #bodyshape, #colour').on(
        'change', _.bind(productsFilter.update, productsFilter)
      )
      @$el.find('#product_order').on('change', _.bind(productsFilter.updateOrder, productsFilter))
      page.enableQuickViewLinks(@$el)

      productsFilter.updateContentHandlers()

    updateContentHandlers: () ->
      # bind quick view
      #@$el.find(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)

      window.addSwitcherToAltImage() if window.addSwitcherToAltImage
      productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
      window.initHoverableProductImages()

      $('.selectbox').chosen()

    update: () ->
      searchData = @getSelectedValues()
      pageUrl = @updatePageLocation(searchData)
      $.ajax(urlWithSitePrefix('/products'),
        type: "GET",
        dataType: 'json',
        data: $.param(searchData)
        success: (data) ->
          productsFilter.$el.find('.category-catalog.products .row').html(data.products_html)
          header = productsFilter.$el.find('.category-header')
          header.find('h2 span em').html(data.page_info.banner_title)
          header.find('p').html(data.page_info.banner_text)

          productsFilter.updateContentHandlers()
          track.pageView(pageUrl, searchData)
      )

    updateOrder: () ->
      @update()

    updatePageLocation: (filter) ->
      url = '/collection'
      if _.isEmpty(filter)
        url = '/collection'
      else if _.isEmpty(filter.collection) || (typeof filter.collection != 'string')
        url = "/collection?#{ $.param(filter) }"
      else # single selected collection
        cleared_filter = _.omit(filter, 'collection')
        if _.isEmpty(cleared_filter)
          url = "/collection/#{filter.collection}"
        else
          url = "/collection/#{filter.collection}?#{$.param(cleared_filter)}"

      url = window.getSiteVersionPrefix() + url
      window.history.pushState({ path: url }, '', url)
      url

    getSelectedValues: () ->
      result = addValue({}, 'style', '#style')
      addValue(result, 'collection', '#collection')
      addValue(result, 'bodyshape', '#bodyshape')
      addValue(result, 'colour', '#colour')
      addValue(result, 'order', '#product_order')
      result
  }

  productsFilter.init($('#content'))
  window.helpers.quickViewer.init()

# $('.filters-block .color').on('click', productsFilter.toggleColorClicked)

#$(".products.index").ready ->
#  # helper method
#  get_value_func = (obj) -> $(obj).val()
#
#  productsFilter = {
#    init: () ->
#      productsFilter.updateContentHandlers()
#
#    changeOrderHandler: (e) ->
#      e.preventDefault()
#      productsFilter.searchProducts.call(productsFilter)
#
#    toggleFilterOptionClicked: (e) ->
#      e.preventDefault()
#      $container = $(e.currentTarget).closest('li')
#      $container.toggleClass('active')
#
#      $input = $container.find('input')
#      $input.prop('checked', $container.is('.active'))
#
#      # if 'all' checked - remove all other
#      # if 'all' unchecked - mark all other as setted
#      # if 'no all' selected - reset 'all'
#      # if 'no all' unselected and no selected elements - select all
#      if $input.val() == 'all'
#        if $container.is('.active')
#          $container.siblings().removeClass('active')
#          $container.siblings().find('input').prop('checked', false)
#        else
#          $container.siblings().addClass('active')
#          $container.siblings().find('input').prop('checked', true)
#      else
#        $all_input = $container.siblings().find('input[value=all]')
#        if $container.is('.active')
#          $all_input.prop('checked', false).closest('li').removeClass('active')
#        else
#          if $container.siblings('.active').length == 0
#            $container.siblings().find('input[value=all]').prop('checked', true).closest('li').addClass('active')
#
#      productsFilter.searchProducts.call(productsFilter)
#
#    toggleColorClicked: (e) ->
#      e.preventDefault()
#      $target = $(e.currentTarget)
#      $target.toggleClass('active')
#
#      # if 'all' checked - remove all other
#      # if 'all' unchecked - mark all other as setted
#      # if 'no all' selected - reset 'all'
#      # if 'no all' unselected and no selected elements - select all
#      if $target.data('color') == 'all'
#        if $target.is('.active')
#          $target.siblings().removeClass('active')
#        else
#          $target.siblings().addClass('active')
#      else
#        if $target.is('.active')
#          $target.siblings('.color.all').removeClass('active')
#        else
#          if $target.siblings('.color.active').length == 0
#            $target.siblings('.color.all').addClass('active')
#
#      productsFilter.searchProducts.call(productsFilter)
#
#    getSelectedTaxons: (name, container) ->
#      result = {}
#      if !container.find('li input[value=all]').is(':checked')
#        selected = _.collect(container.find('li input:checked'), get_value_func)
#
#      # process result
#      # don't spam params with empty
#      # send without nasty [] if only one argument
#      if _.isEmpty(selected)
#        return result
#      else
#        selected = selected[0] if selected.length == 1
#        result[name] = selected
#        return result
#
#    currentFilter: () ->
#      filter = {}
#
#      # collection
#      selectedCollection = productsFilter.getSelectedTaxons('collection', $('ul.filters-boxes.collection'))
#      _.extend(filter, selectedCollection)
#
#      # style
#      selectedStyles = productsFilter.getSelectedTaxons('style', $('ul.filters-boxes.style'))
#      _.extend(filter, selectedStyles)
#
#      # colours
#      container = $('.filters-block .colors')
#      if !container.find('.color.all').is('.active')
#        choosenColors = _.collect(container.find('.color.active'), (obj) -> $(obj).data('color'))
#        unless _.isEmpty(choosenColors)
#          if choosenColors.length == 1
#            filter.colour = choosenColors[0]
#          else
#            filter.colour = choosenColors
#
#      # body shapes
#      selectedShapes = productsFilter.getSelectedTaxons('bodyshape', $('ul.filters-boxes.body_shapes'))
#      _.extend(filter, selectedShapes)
#
#      # order
#      selectedOrder = $('#product_order').val()
#      filter.order = selectedOrder unless _.isEmpty(selectedOrder)
#
#      return filter
#
#    updatePageLocation: (filter) ->
#      url = '/collection'
#      if _.isEmpty(filter)
#        url = '/collection'
#      else if _.isEmpty(filter.collection) || (typeof filter.collection != 'string')
#        url = "/collection?#{ $.param(filter) }"
#      else # single selected collection
#        cleared_filter = _.omit(filter, 'collection')
#        if _.isEmpty(cleared_filter)
#          url = "/collection/#{filter.collection}"
#        else
#          url = "/collection/#{filter.collection}?#{$.param(cleared_filter)}"
#
#      url = window.getSiteVersionPrefix() + url
#      window.history.pushState({ path: url }, '', url)
#      url
#
#    searchProducts: () ->
#      searchData = @currentFilter()
#      pageUrl = @updatePageLocation(searchData)
#
#      $.ajax(urlWithSitePrefix('/products'),
#        type: "GET",
#        dataType: 'html',
#        data: $.param(searchData)
#        success: (html) ->
#          $('.grid-75.fright').html(html)
#          productsFilter.updateContentHandlers()
#          track.pageView(pageUrl, searchData)
#      )
#
#    updateContentHandlers: () ->
#      # bind quick view
#      $(".quick-view a[data-action='quick-view']").on('click', window.helpers.quickViewer.onShowButtonHandler)
#      $('#product_order').on('change', productsFilter.changeOrderHandler)
#
#      window.addSwitcherToAltImage() if window.addSwitcherToAltImage
#      productWishlist.addWishlistButtonActions($("a[data-action='add-to-wishlist']"))
#      window.initHoverableProductImages()
#
#      $('.selectbox').chosen()
#  }
#
#  window.helpers.quickViewer.init()
#  productsFilter.init()
#
#  $('.filters-block .filters-boxes li label').on('click', productsFilter.toggleFilterOptionClicked)
#  $('.filters-block .color').on('click', productsFilter.toggleColorClicked)
