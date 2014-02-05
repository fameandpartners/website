window.popups or= {}

window.popups.getModalContainer = (title = null, button = null) ->
  options = { title: title, button: button }
  if $('.modal.popup-placeholder').length == 0
    $('body.ecommerce #wrap #content').append(JST['templates/modal_popup'](options))
  else
    $('.modal.popup-placeholder').replaceWith(JST['templates/modal_popup'](options))

  container = $('.modal.popup-placeholder').hide()
  return container

window.popups.getQuickViewModalContainer = () ->
  container = window.popups.getModalContainer()
  container.addClass('quick-view-mode')
  container.find('.modal-container').addClass('quick-view')
  container.find('.item').replaceWith($("<div class='product-page grid-container'></div>"))
  container
