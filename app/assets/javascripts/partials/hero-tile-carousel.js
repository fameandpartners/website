'use strict';
(function ($) {

  var slickCarousel = $('.js-hero-tile-carousel');

  // Hero Tile Carousel
  slickCarousel.slick({
    autoplay: true,
    autoplaySpeed: 8000,
    speed: 1500,
    fade: true,
    arrows: true,
    dots: false,
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

})(jQuery);
