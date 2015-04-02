$(document).ready ->
  $("#theTarget").skippr({
    logs: false,
    transition: 'fade',
    speed: 1000,
    easing: 'easeOutQuart',
    navType: 'block',
    childrenElementType: 'div',
    arrows: false,
    autoPlay: true,
    autoPlayDuration: 7000,
    keyboardOnAlways: true,
    hidePrevious: false
  })

  $('.slider-action').on 'click', (e) ->
    # e.preventDefault()
    window.location = $(this).data('href')

  $('.selectbox').chosen
    inherit_select_classes: true
    disable_search: true

$(window).resize( () ->
  $('#theTarget').css("z-index", 1)
)
