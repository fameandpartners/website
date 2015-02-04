$(document).ready ->
  $("#theTarget").skippr({
    transition: 'fade',
    speed: 1000,
    easing: 'easeOutQuart',
    navType: 'block',
    childrenElementType: 'div',
    arrows: false,
    autoPlay: false,
    autoPlayDuration: 7000,
    keyboardOnAlways: true,
    hidePrevious: false
  })

$(window).resize( () ->
  $('#theTarget').css("z-index", 1)
)
