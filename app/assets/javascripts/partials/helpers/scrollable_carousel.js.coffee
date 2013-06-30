window.helpers or= {}

# add feature to scroll carousel with mouse scroll
window.helpers.scrollable_carousel = (images) ->
  scrollBack = () ->
    $(images).trigger("prev")

  scrollForward = () ->
    $(images).trigger("next")

  timeoutId = null
  executeAndWait = (callbackFunc) ->
    timeoutFunc = () ->
      callbackFunc.apply()
      timeoutId = null

    timeoutId = setTimeout(timeoutFunc, 100) if !timeoutId

  $(images).on('mousewheel', (e, delta, deltaX, deltaY) ->
    e.preventDefault()
    if deltaY > 0
      executeAndWait(scrollBack)
    else if deltaY < 0
      executeAndWait(scrollForward)
  )

  return carousel
