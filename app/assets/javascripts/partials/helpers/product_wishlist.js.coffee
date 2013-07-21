  productWishlist = {
    addWishlistButtonActions: (container) ->
      container.on('click', (e) ->
        e.preventDefault()
        variantId = $(e.currentTarget).data("id")

        button = $(e.currentTarget)
        previousButtonText = button.html()
        button.addClass('adding')
        window.productWishlist.addProduct.call(productWishlist, variantId, {
          success: () -> button.removeClass('adding').html('Unlike Item').addClass('active')
          failure: () -> button.removeClass('adding').html(previousButtonText).addClass('active')
        })
      )

    onClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data("id")
      productWishlist.addProduct.call(productWishlist, variantId)

    addProduct: (variantId, options = {}) ->
      return unless variantId?
      options = _.extend({ variant_id: variantId, quantity: 1}, options)
      $.ajax(
        url: "/wishlists_items"
        type: 'POST'
        dataType: 'json'
        data: productWishlist.prepareParams(options)
        success: productWishlist.buildSuccessCallback(options)
        error: productWishlist.buildErrorCallback(options)
      )

    prepareParams: (options = {}) ->
      data = {}
      for key of options
        if !_.isFunction(options[key])
          data[key] = options[key]
      return $.param(data)

    buildSuccessCallback: (options) ->
      callback = () ->
        options.success.apply(window, arguments) if options.success
      return callback

    buildErrorCallback: (options) ->
      callback = () ->
        options.failure.apply(window, arguments) if options.failure
      return callback
  }
  window.productWishlist = productWishlist
