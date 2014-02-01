window.popups or= {}

window.popups.getModalContainer = (title, button) ->
  if $('.modal.popup-placeholder').length == 0
    $('body.ecommerce #wrap #content').append(JST['templates/modal_popup']())
  else
    $('.modal.popup-placeholder').replaceWith(JST['templates/modal_popup']())

  container = $('.modal.popup-placeholder').hide()
  container.find('.modal-title').html(title)
  container.find('input.btn.black').html(button)
  return container

