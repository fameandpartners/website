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

  window.hideCelebrityModal = ->
    $celebrity_modal.addClass('hidden')
#    if window.main_disqus_url
#      $('#disqus_thread').remove()
#      $(window.main_dicuss_container).append("<div id='disqus_thread'></div>")
#
#      window.disqus_identifier = window.main_disqus_identifier
#      window.disqus_url = window.main_disqus_url
#
#      if window.DISQUS
#        DISQUS.reset
#          reload: true
#          config: ->
#            this.page.identifier = window.disqus_identifier
#            this.page.url = window.disqus_url
#      else
#        dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
#        disqus_shortname = 'fameandpartners'
#        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
#        window.disqus_identifier = disqus_identifier
#        window.disqus_url = disqus_url
#        $('head').append(dsq)

  window.showCelebrityModal = (e) ->
    $('.celebrity-modal').removeClass('hidden')
    $('.celebrity-modal .celebrity-blocks').css({top: $(document).scrollTop() + 100 + 'px'})
    $('.celebrity-modal .close-modal').css({top: $(document).scrollTop() + 15 + 'px'})
    window.updateCelebrityModal($(e.target).parent())

  window.updateCelebrityModal = (item) ->
    $parent = $(item)
    photo_id = $parent.find('.love-share .icons').attr('data-id')
    is_like = $parent.find('.love-share .icons .love').hasClass('active')
    is_dislike = $parent.find('.love-share .icons .hate').hasClass('active')

    name      = $parent.attr('data-name')
    photo_url = $parent.attr('data-photo-url')
    comments_url = $parent.attr('data-comments-url')
    if photo_url == ""
      photo_url = 'http://placehold.it/576x770'
    date      = $parent.attr('data-date')

    #    $('#disqus_thread').remove()
    #    $('.block-comments').append("<div id='disqus_thread'></div>")
    #
    #    window.disqus_identifier = "photo-#{photo_id}"
    #    window.disqus_url = "http://www.fameandpartners.com/photos/#{photo_id}"
    #
    #    if window.DISQUS
    #      DISQUS.reset
    #        reload: true
    #        config: () ->
    #          this.page.identifier = window.disqus_identifier
    #          this.page.url = window.disqus_url
    #    else
    #      dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    #      disqus_shortname = 'fameandpartners'
    #      dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
    #      window.disqus_identifier = disqus_identifier
    #      window.disqus_url = disqus_url
    #      $('head').append(dsq)

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

    $celebrity_modal.find('.celebrity-next, .celebrity-prev').unbind('click')

    if $parent.siblings().size() > 0
      $celebrity_modal.find('.celebrity-next, .celebrity-prev').show()

      $children = $parent.parent().children()
      $next = if $parent.next().size() isnt 0 then $parent.next() else $children.filter(':first')
      $prev = if $parent.prev().size() isnt 0 then $parent.prev() else $children.filter(':last')

      $celebrity_modal.find('.celebrity-next').bind 'click', () ->
        window.updateCelebrityModal($next)
      $celebrity_modal.find('.celebrity-prev').bind 'click', () ->
        window.updateCelebrityModal($prev)

    else
      $celebrity_modal.find('.celebrity-next, .celebrity-prev').hide()



  $('.celebrity-modal .close-modal a').on 'click', ->
    window.hideCelebrityModal()
    false

  $('.celebrity-modal .overlay').on 'click', ->
    window.hideCelebrityModal()
    false

  $(document).on 'keyup', (e) ->
    if e.keyCode == 27
      modal = $('.celebrity-modal')
      if !$celebrity_modal.hasClass('hidden')
        window.hideCelebrityModal()
    true

  $(document).on 'click', '.zoom', window.showCelebrityModal

  $('.icons .love').on 'click', (e) ->
    $this = $(this)
    photo_id = $this.parent().attr('data-id')
    $this.addClass('active')
    $this.parent().find('.hate').removeClass('active')
    $.ajax
      method: 'post'
      url: urlWithSitePrefix("/celebrity_photo/#{photo_id}/like.json")
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
      url: urlWithSitePrefix("/celebrity_photo/#{photo_id}/dislike.json")
      success: (data) ->
        true
      error: (data) ->
        if data.status is 401
          window.location = '/login'
    false
