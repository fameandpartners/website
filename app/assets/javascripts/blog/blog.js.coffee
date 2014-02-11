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

    $blogCarouselPager = $blogCarouselBox.find('.controls').find('.pager')
    _.map($blogCarousel.find('li'), 

  pagerStr = _.reduce($blogCarousel.find('li'), (str, element, key) ->
    str += "<a href='#' "
  )

}

  $blogCarouselBox = $('.blog-carousel');
  $blogCarousel = $blogCarouselBox.find('.carousel');
  pagerStr = '';
  $blogCarouselPager = $blogCarouselBox.find('.controls').find('.pager')
  for (var i = 0; i < $blogCarousel.find('li').length; i++ ) 
    pagerStr += '<a href="#" data-slide-index="'+i+'"></a>'
  $blogCarouselPager.html(pagerStr);

  // init carousel
  $blogCarousel.bxSlider({
    minSlides: 3,
    maxSlides: 3,
    slideWidth: 460,
    slideMargin: 5,
    moveSlides: 1,
    pagerCustom:  '.blog-carousel .pager',
    nextSelector: '.blog-carousel .next',
    prevSelector: '.blog-carousel .prev',
    onSlideAfter: function($slideElement, oldIndex, newIndex) {
      $slideElement.addClass('current').siblings('li').removeClass('current next-slide prev-slide');
      $slideElement.removeClass('next-slide').next().addClass('next-slide');
      $slideElement.removeClass('prev-slide').prev().addClass('prev-slide');
    }
  });

