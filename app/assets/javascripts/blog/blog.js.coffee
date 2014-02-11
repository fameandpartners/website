window.blog = {
  container: $('#blog')
  track_conversion: (action_name) ->
    track.conversion('blog_view')

  enable_search: () ->
    if $('.blog-header').length > 0
      $('.toggle-search').on('click', (e) ->
        e.preventDefault()
        $('.blog-header .search').toggle()
      )

  enable_carousel_slider: () ->
    $blogCarouselBox = $('.blog-carousel')
    $blogCarousel = $blogCarouselBox.find('.carousel')

    $blogCarouselPager = $blogCarouselBox.find('.controls').find('.pager').empty()
    _.each($blogCarousel.find('li'), (element, index, list) ->
      $blogCarouselPager.append($('<a>', { href: '#', 'data-slide-index': index}))
    )

    $blogCarousel.bxSlider
      minSlides: 3
      maxSlides: 3
      slideWidth: 460
      slideMargin: 5
      moveSlides: 1
      pagerCustom:  '.blog-carousel .pager'
      nextSelector: '.blog-carousel .next'
      prevSelector: '.blog-carousel .prev'

      onSlideAfter: ($slideElement, oldIndex, newIndex) ->
        $slideElement.addClass('current').siblings('li').removeClass('current next-slide prev-slide')
        $slideElement.removeClass('next-slide').next().addClass('next-slide')
        $slideElement.removeClass('prev-slide').prev().addClass('prev-slide')
}
