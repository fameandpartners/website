# enable this to show fixed bar on top when user scrolls to end of page
###
$('.index.show').ready ->
  toggleFixedBar = () ->
    $bar = $('.fixed-bar')

    if ($(window).scrollTop() > 666 && !$bar.data('visible'))
      $(window).off('scroll', toggleFixedBar)

      $bar.animate({top: 0}, 300, () ->
        $(window).on('scroll', toggleFixedBar)
        $bar.data('visible', true)
        $bar.show()
      )

    else if ($(window).scrollTop() < 666 && $bar.data('visible'))
      $(window).off('scroll', toggleFixedBar)

      $bar.animate({top: '-300px'}, 300, () ->
        $(window).on('scroll', toggleFixedBar)
        $bar.data('visible', false)
      )

  $(window).on('scroll', toggleFixedBar)
###
