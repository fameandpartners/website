$(".products.show").ready ->

  # enable carousel
  carousel = $("#product-items").carouFredSel
    items: 4
    width: 1094
    circular: false
    infinite: false
    auto: false
    prev:
      button: "#product-items-prev"
      key: "left"
      items: 4

    next:
      button: "#product-items-next"
      key: "right"
      items: 4


  # add feature to scroll carousel with mouse scroll
  scrollBack = () ->
    $("#product-images").trigger("prev")

  scrollForward = () ->
    $("#product-images").trigger("next")

  timeoutId = null
  executeAndWait = (callbackFunc) ->
    timeoutFunc = () ->
      callbackFunc.apply()
      timeoutId = null

    timeoutId = setTimeout(timeoutFunc, 100) if !timeoutId

  $('#product-images').bind('mousewheel', (e, delta, deltaX, deltaY) ->
    e.preventDefault()
    if deltaY > 0
      executeAndWait(scrollBack)
    else if deltaY < 0
      executeAndWait(scrollForward)
  )
