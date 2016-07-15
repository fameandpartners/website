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
    edgeFriction: 10,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          speed: 400,
          fade: false,
          slidesToShow: 1,
          slidesToScroll: 1
        }
      }
    ]
  });

})(jQuery);
