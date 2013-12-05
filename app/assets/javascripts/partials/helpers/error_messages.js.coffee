window.helpers or= {}

window.helpers.showErrors = (container, messageText) ->
  console.log('here')
  block = container.find('.error.message')
  if block.length == 0
    container.append($("<span class='error message' style='display: none;'></span>"))
    block = container.find('.error.message')
  block.text(messageText).fadeIn()
  setTimeout( () ->
    window.helpers.hideErrors(container)
  , 3000)

window.helpers.hideErrors = (container, duration = 'slow') ->
  container.find('.error.message').fadeOut(duration)
