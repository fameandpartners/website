'use strict';
(function ($) {

  var slickSelector = '.js-hero-tile-carousel';
  var slickCarousel = $(slickSelector);

  // -----------------------------------
  // HERO TILE CUSTOM NAVIGATION
  // Reason: Our hero tiles on mobile do not work well with Slick's 'dots: true' (.slick-dots), so let's customize the slide navigation a bit.

  // Loop through our current slides
  $(slickSelector + ' .hero-wrap').each(function( index ) {

    var total_slides = $(slickSelector + ' .hero-wrap').length;
    var i, current_div = (index + 1);

    // Create slider navigation wrapper
    $('<ul />', {'class': 'hero-carousel-nav'}).appendTo(slickSelector + ' .hero-wrap:nth-of-type('+current_div+') picture');

    for (i = 0; i < total_slides; i++) {

      //Create navigation links
      $('<li />', {'class': 'item-nav'}).appendTo(slickSelector + ' .hero-wrap:nth-of-type('+current_div+') picture ul');

      // Match each nav link to each slide
      $(this).find('.item-nav:nth-of-type('+current_div+')').addClass('current');
    }

    // Add <a> tags (just to make the squares)
    $('.hero-wrap:nth-of-type('+current_div+') picture .item-nav').append('<a href="javascript:;"></a>');

    // Why click on <li> and not <a>?
    // This is for UX, as users might find it difficult to click on the small squares (which are <a> tags).
    // Some extra padding has been added around <li>'s via CSS and now everybody can click correctly, even if they have clumsy fingers! \o/ \o/ \o/
    $('.item-nav').click(function(e){
     var slideIndex = $(this).index();
     // Go to specific slide on click
     slickCarousel.slick('slickGoTo', parseInt(slideIndex) );
    });

  });
  // -----------------------------------

  // Hero Tile Carousel
  slickCarousel.slick({
    autoplay: true,
    autoplaySpeed: 8000,
    speed: 1500,
    fade: true,
    arrows: false,
    dots: false, // This must be set always as 'false' in favor of the custom navigation function above.
    edgeFriction: 10,
    slidesToShow: 1,
    slidesToScroll: 1,
    focusOnSelect: true,
    responsive: [
      {
        breakpoint: 992,
        settings: {
          speed: 400,
          fade: false
        }
      }
    ]
  });

  // Carousel controlled by external triggers (previous | next)
  var selectorCarouselControlledByNavTrigger = $('.js-carouselControledByNavTrigger');
  selectorCarouselControlledByNavTrigger.slick({
    autoplay: false,
    arrows: false,
    dots: false,
    mobileFirst: true,
    focusOnSelect: true,
    infinite: true
  });

  $('.js-carouselControledByNavTrigger__previous').click(function(){
    selectorCarouselControlledByNavTrigger.slick('slickPrev');
  });

  $('.js-carouselControledByNavTrigger__next').click(function(){
    selectorCarouselControlledByNavTrigger.slick('slickNext');
  });

})(jQuery);
