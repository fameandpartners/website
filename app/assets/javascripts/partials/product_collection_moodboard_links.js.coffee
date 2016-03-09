# usage
# initProductCollectionMoodboardLinks(
#   buttons:   '.js-trigger-add-to-moodboard'
# )
window.initProductCollectionMoodboardLinks = (options = {}) ->
  $buttons_selector = $(options.buttons)

  if !app.user_signed_in
    $buttons_selector.removeAttr('data-toggle')

  showMoodboardDropdown = (e) ->
    if !app.user_signed_in
      e.preventDefault()
      window.redirectToLoginAndBack()
      return

  $buttons_selector.on('click', showMoodboardDropdown)
