$ ->
  $(".blog-slider .slides").carouFredSel
    circular: false
    infinite: false
    responsive: true
    auto: false
    scroll:
      fx: "slide"

    pagination: ".blog-slider .pagination"

  $("#post-carousel").carouFredSel
    circular: true
    infinite: true
    items: 1
    auto: false
    prev:
      button  : "#post-carousel-prev"
      key   : "left"
    next:
      button  : "#post-carousel-next"
      key   : "right"
    auto: true
    width: 644
    height: 355

  $celebrity_modal = $('.celebrity-modal')

  $('.celebrity-modal .close-modal a').on 'click', ->
    $celebrity_modal.addClass('hidden')
    false

  $('.zoom').on 'click', (e) ->
    $parent = $(e.target).parent()
    $('.celebrity-modal').removeClass('hidden')
    $("body").animate({"scrollTop":0},10)

    name      = $parent.attr('data-name')
    photo_url = $parent.attr('data-photo-url')
    date      = $parent.attr('data-date')

    $celebrity_modal.find('.name').html(name)
    $celebrity_modal.find('.celebrity-main img').attr('src', photo_url)
    $celebrity_modal.find('.post-meta .date').attr('src', date)

    false
