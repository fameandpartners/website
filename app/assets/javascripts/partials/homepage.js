'use strict';
(function ($) {

  // Hero Tile Carousel
  $('.hero-tile-carousel').slick({
    autoplay: true,
    autoplaySpeed: 8000,
    speed: 1500,
    fade: true,
    arrows: false,
    dots: true,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          speed: 800,
          fade: false,
          slidesToShow: 1,
          slidesToScroll: 1
        }
      }
    ]
  });

})(jQuery);
