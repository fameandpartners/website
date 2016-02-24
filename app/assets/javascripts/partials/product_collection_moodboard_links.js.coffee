# usage
# initProductCollectionMoodboardLinks(
#   container: '.category .products-collection',
#   buttons:   'span.moodboard.add-to-moodboard'
# )
window.initProductCollectionMoodboardLinks = (options = {}) ->
  $container = $(options.container)
  buttons_selector = options.buttons

  showMoodboardDropdown = (e) ->
    e.preventDefault()

    if !app.user_signed_in
      window.redirectToLoginAndBack()
      return
    $(".dropdown-menu", $(e.currentTarget).parent()).toggleClass("hide")

  $container.on('click', buttons_selector, showMoodboardDropdown)
