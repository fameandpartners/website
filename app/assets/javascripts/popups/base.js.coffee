window.popups or= {}

window.popups.getModalContainer = (title = null, button = null) ->
  options = { title: title, button: button }
  container = $(JST['templates/modal_popup'](options)).hide()
  if $('.modal.popup-placeholder').length == 0
    $('body #wrap #content').append(container)
  else
    $('.modal.popup-placeholder').replaceWith(container)

  return container

window.popups.getQuickViewModalContainer = () ->
  container = window.popups.getModalContainer()
  container.addClass('quick-view-mode')
  container.find('.modal-container').addClass('quick-view')
  container.find('.item').replaceWith($("<div class='product-page grid-container'></div>"))
  container.hide()

  container
