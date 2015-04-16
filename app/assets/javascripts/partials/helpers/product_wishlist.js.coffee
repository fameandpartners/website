window.productWishlist = {
  # item { spree_product_id: 1, spree_variant_id: 2, quantity: 1 }
  items: []
  events_bus: $({})

  initialize: () ->
    window.productWishlist.__initialize.apply(window.productWishlist, arguments)

  __initialize: () ->
    _.bindAll(@, 'toggleLinkHandler', 'updateLinkState')
    if _.isEmpty(window.bootstrap) || _.isEmpty(window.bootstrap.wishlist_items)
      @items = []
    else
      @items = window.bootstrap.wishlist_items
    return @

  addWishlistButtonActions: (elements) ->
    return false if _.isUndefined(window.current_user)

    $(elements).on('click', window.productWishlist.toggleLinkHandler)

    _.each($(elements), (el) ->
      element = $(el)
      element.attr('href', '#')
      product_id = element.data('product-id')
      productWishlist.updateLinkState(element)
      window.productWishlist.events_bus.on('changed', (event, data) ->
        productWishlist.updateLinkState(element) if product_id == data.spree_product_id
      )
    )

  toggleLinkHandler: (e) ->
    e.preventDefault()
    product_id = $(e.currentTarget).data('product-id')
    color_id = $(e.currentTarget).data('color-id')
    if productWishlist.isInWishlist(product_id, color_id)
      productWishlist.removeProduct(product_id, color_id)
    else
      variant_id = $(e.currentTarget).data('id')
      productWishlist.addProduct(product_id, quantity: 1, variant_id: variant_id, color_id: color_id)

  addProduct: (product_id, options = {}) ->
    options = _.extend({ product_id: product_id, quantity: 1}, options)
    $.ajax(
      url: urlWithSitePrefix("/wishlists_items")
      type: 'POST'
      dataType: 'json'
      data: options
      success: (data) ->
        item = JSON.parse(data.item)
        unless productWishlist.isInWishlist(item.spree_product_id)
          productWishlist.items.push(item)
        productWishlist.events_bus.trigger('changed', item)
        track.addedToWishlist(data.analytics_label) if data.analytics_label?
    )

  removeProduct: (product_id) ->
    item = _.findWhere(productWishlist.items, { spree_product_id: product_id })
    return if _.isUndefined(item)
    $.ajax(
      url: urlWithSitePrefix("/wishlists_items/#{ item.id }")
      type: 'DELETE'
      dataType: 'json'
      success: (data) ->
        if productWishlist.isInWishlist(item.spree_product_id)
          productWishlist.items = _.reject(productWishlist.items, (element) ->
            element.product_id = item.spree_product_id
          )
        productWishlist.events_bus.trigger('changed', item)
        track.removedFromWishlist(data.analytics_label) if data.analytics_label?
    )

  # internal methods
  updateLinkState: (element) ->
    product_id = $(element).data('product-id')
    if @isInWishlist(product_id)
      element.html(element.data('title-remove'))
    else
      element.html(element.data('title-add'))

  isInWishlist: (product_id, color_id) ->
    product_id = parseInt(product_id)
    result = _.findWhere(productWishlist.items, { spree_product_id: product_id })
    return !_.isUndefined(result)
}
