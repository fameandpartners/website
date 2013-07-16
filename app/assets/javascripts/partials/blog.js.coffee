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
    width: '100%'
    height: 355

  $celebrity_modal = $('.celebrity-modal')

  $('.celebrity-modal .close-modal a').on 'click', ->
    $celebrity_modal.addClass('hidden')
    false

  $('.zoom').on 'click', (e) ->
    $parent = $(e.target).parent()
    $('.celebrity-modal').removeClass('hidden')
    $("body").animate({"scrollTop":0},10)
    photo_id = $parent.find('.love-share .icons').attr('data-id')
    is_like = $parent.find('.love-share .icons .love').hasClass('active')
    is_dislike = $parent.find('.love-share .icons .hate').hasClass('active')

    name      = $parent.attr('data-name')
    photo_url = $parent.attr('data-photo-url')
    comments_url = $parent.attr('data-comments-url')
    if photo_url == ""
      photo_url = 'http://placehold.it/576x770'
    date      = $parent.attr('data-date')

    $celebrity_modal.find('.name').html(name)
    $celebrity_modal.find('.icons').attr('data-id', photo_id)
    $celebrity_modal.find('.celebrity-main img').attr('src', photo_url)
    $celebrity_modal.find('.post-meta .date').attr('src', date)
    if is_like
      $celebrity_modal.find('.icons .love').addClass('active')
      $celebrity_modal.find('.icons .hate').removeClass('active')
    else if is_dislike
      $celebrity_modal.find('.icons .hate').addClass('active')
      $celebrity_modal.find('.icons .love').removeClass('active')
    else
      $celebrity_modal.find('.icons .hate').removeClass('active')
      $celebrity_modal.find('.icons .love').removeClass('active')
    $comments = $celebrity_modal.find('.comments')
    $comments.empty()
    $comments.append $("<a href='#{comments_url}#disqus_thread'></a>")

  $('.icons .love').on 'click', (e) ->
    $this = $(this)
    photo_id = $this.parent().attr('data-id')
    $this.addClass('active')
    $this.parent().find('.hate').removeClass('active')
    $.ajax
      method: 'post'
      url: "/celebrity_photo/#{photo_id}/like.json"
      success: (data) ->
        true
      error: (data) ->
        if data.status is 401
          window.location = '/login'
    false

  $('.icons .hate').on 'click', (e) ->
    $this = $(this)
    $this.addClass('active')
    $this.parent().find('.love').removeClass('active')
    photo_id = $this.parent().attr('data-id')
    $.ajax
      method: 'post'
      url: "/celebrity_photo/#{photo_id}/dislike.json"
      success: (data) ->
        true
      error: (data) ->
        if data.status is 401
          window.location = '/login'
    false
