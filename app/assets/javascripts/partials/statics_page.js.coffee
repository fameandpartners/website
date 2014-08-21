$('.statics.landingpage_plus_size').ready ->
  
  enable_carousel_slider: () ->
    $plusSizeCarouselBox = $('.plus-size-carousel')
    $plusSizeCarousel = $plusSizeCarouselBox.find('.carousel')

    $plusSizeCarouselPager = $plusSizeCarouselBox.find('.controls').find('.pager').empty()
    _.each($plusSizeCarousel.find('li'), (element, index, list) ->
      $plusSizeCarouselPager.append($('<a>', { href: '#', 'data-slide-index': index}))
    )

    $plusSizeCarousel.bxSlider
      minSlides: 3
      maxSlides: 3
      slideWidth: 460
      slideMargin: 5
      moveSlides: 1
      pagerCustom:  '.plus-size-carousel .pager'
      nextSelector: '.plus-size-carousel .next'
      prevSelector: '.plus-size-carousel .prev'

      onSlideAfter: ($slideElement, oldIndex, newIndex) ->
        $slideElement.addClass('current').siblings('li').removeClass('current next-slide prev-slide')
        $slideElement.removeClass('next-slide').next().addClass('next-slide')
        $slideElement.removeClass('prev-slide').prev().addClass('prev-slide')