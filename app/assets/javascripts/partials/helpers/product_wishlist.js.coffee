  productWishlist = {
    addWishlistButtonActions: (container) ->
      container.on('click', (e) ->
        e.preventDefault()
        variantId = $(e.currentTarget).data("id")

        likeIndicator = helpers.buildLoadingIndicator($(e.currentTarget), { indicator_type: 'spinner' })
        likeIndicator.showLoading()
        window.productWishlist.addProduct.call(productWishlist, variantId, {
          success: likeIndicator.hideLoading
          failure: likeIndicator.hideLoading
        })
      )

    onClickHandler: (e) ->
      e.preventDefault()
      variantId = $(e.currentTarget).data("id")
      productWishlist.addProduct.call(productWishlist, variantId)

    addProduct: (variantId, options = {}) ->
      return unless variantId?
      options = _.extend({ variant_id: variantId }, options)
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
