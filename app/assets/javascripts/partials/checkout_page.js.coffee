$(".checkout.edit").ready ->
  accordion = {
    toggleClickHandler: (e) ->
      e.preventDefault()
      $content = $(e.currentTarget).next('.accordion-content')

      if $(e.currentTarget).toggleClass('active').is('.active')
        $content.slideDown()
      else
        $content.slideUp()

    init: () ->
      # close all content
      $('.accordion-container .accordion-title').removeClass('active')
      $('.accordion-container .accordion-content').hide()
  }

  accordion.init()
  $('.accordion-container .accordion-title').on("click", accordion.toggleClickHandler)
