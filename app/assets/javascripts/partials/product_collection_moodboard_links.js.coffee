# usage
# initProductCollectionMoodboardLinks(
#   container: '.category .products-collection',
#   buttons:   'span.moodboard.add-to-moodboard'
# )
window.initProductCollectionMoodboardLinks = (options = {}) ->
  $container = $(options.container)
  buttons_selector = options.buttons

  addProductToMoodboardHandler = (e) ->
    e.preventDefault()
    item = $(e.currentTarget).closest('div[data-id]')
    moodboard_item_options = { product_id: item.data('id'), color_id: item.data('color-id') }

    app.user_moodboard.one('change', (e) ->
      if app.user_moodboard.contains(moodboard_item_options)
        item.find(buttons_selector).remove()
    )
    app.user_moodboard.addItem(moodboard_item_options)

  $container.on('click', buttons_selector, addProductToMoodboardHandler)
