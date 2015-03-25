# usage
# initProductCollectionMoodboardLinks(
#   container: '.category .products-collection',
#   buttons:   'span.moodboard.add-to-moodboard'
# )
window.initProductCollectionMoodboardLinks = (options = {}) ->
  $container = $(options.container)
  buttons_selector = options.buttons

  addProductToMoodboardClickHandler = (e) ->
    e.preventDefault()

    if !app.user_signed_in
      window.redirectToLoginAndBack()
      return

    return if $(e.currentTarget).data('loading')
    $(e.currentTarget).data('loading', true)

    item = $(e.currentTarget).closest('div[data-id]')
    moodboard_item_options = { product_id: item.data('id'), color_id: item.data('color-id') }

    app.user_moodboard.one('change', (e) ->
      if app.user_moodboard.contains(moodboard_item_options)
        item.find(buttons_selector).replaceWith($('<a>', href: urlWithSitePrefix('/wishlist'), html: 'Added to Moodboard'))
    )
    app.user_moodboard.addItem(moodboard_item_options)

  $container.on('click', buttons_selector, addProductToMoodboardClickHandler)
