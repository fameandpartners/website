'use strict';
(function ($) {

  // Get useful data before any interaction
  var $navHeightDesktop = 0,
      $navHeightLocalMenu = 0,
      $localNavOffsetTop = 0;

  if ($("#fixed-header").length)
    var $navHeightDesktop = $("#fixed-header").delay(300).outerHeight();

  if ($(".js-float-menu-on-scroll").length)
    var $navHeightLocalMenu = $(".js-float-menu-on-scroll").delay(300).outerHeight();

  if ($(".local-navigation-wrapper .js-float-menu-on-scroll").length)
    var $localNavOffsetTop = $(".local-navigation-wrapper .js-float-menu-on-scroll").offset().top;

    var $offsetHeight = $navHeightDesktop+$navHeightLocalMenu,
        $offsetHeightExtra = 45, // The desired distance between the target and the fixed header + local navigation
        $mdScreenWidth = 992;

  // Add DOM helper if we are loading this page directly from an URL containing an anchor (/something#foo=bar)
  // This is needed for our fixed header and floating menu
  if ( window.location.hash ) {
    var $hash = window.location.hash,
        $id   = $hash.slice(1),
        $elem = document.getElementById($id),
        $hashlink = '<div id='+$id+' class="hashlink js-hashlink"></div>';

    $elem.removeAttribute('id');
    $elem.insertAdjacentHTML('beforebegin', $hashlink);
    if ($(".local-navigation .nav").length) {
      $('.js-hashlink').css({'height': ($offsetHeight-$offsetHeightExtra)+'px', 'margin-top': -($offsetHeight-$offsetHeightExtra)+'px'});
    } else {
      $('.js-hashlink').css({'height': $offsetHeight+'px', 'margin-top': -$offsetHeight+'px'});
    }
    window.location.hash = $hash;
  }

  // Check if we have any floating menu in the page
  if ($('.js-float-menu-on-scroll').length) {

    // Add scrollspy trigger
    $('body').scrollspy({ target: '.js-float-menu-on-scroll', offset: ($offsetHeight+$offsetHeightExtra) })

    // Watch scrolling to show/hide floating menu
    $(document).delay(500).on("scroll", function() {
      var $windowPosition = $(window).scrollTop();

      // Toggle floating menu if window position is below the target element
      // if ($windowPosition < ($localNavOffsetTop+$navHeightLocalMenu)) {
      if ($windowPosition+$navHeightDesktop >= $(".local-navigation-wrapper").offset().top+$navHeightLocalMenu){
        if ($('.js-float-menu-on-scroll.fixed-nav').length) {
          $('.js-float-menu-on-scroll.fixed-nav').fadeIn(100);
          $('.local-navigation-wrapper .js-float-menu-on-scroll').addClass('fixed-nav-mobile').fadeIn(100);
        } else {
          $('.local-navigation-wrapper .js-float-menu-on-scroll').clone().addClass('fixed-nav').appendTo('#fixed-header').fadeIn(100);
        }
      } else {
        if ($('.js-float-menu-on-scroll.fixed-nav').length) {
          $('.js-float-menu-on-scroll.fixed-nav').fadeOut(300);
          $('.local-navigation-wrapper .js-float-menu-on-scroll').removeClass('fixed-nav-mobile');
        }
      }

    });

    // Responsive floating menu as a Carousel on mobile
    if ($(".local-navigation .nav").length) {
      var $window = $(window),
          $toggleSlick,
          $responsiveNavLocal = $('.local-navigation .nav')

      $toggleSlick = function () {
        if ($window.width() < $mdScreenWidth) {
          if(!$responsiveNavLocal.hasClass('slick-initialized')) {
            $responsiveNavLocal.slick({
              autoplay: false,
              fade: false,
              arrows: false,
              dots: false,
              edgeFriction: 10,
              slidesToShow: 4,
              slidesToScroll: 1,
              variableWidth: true,
              infinite: true,
              focusOnSelect: true,
              mobileFirst: true
            });
          }
        } else {
          if($responsiveNavLocal.hasClass('slick-initialized')) {
            $responsiveNavLocal.slick('unslick');
          }
        }
      }

      $window.delay(500).resize($toggleSlick);
      $toggleSlick();
    }

  }

  // Watch clicks on anchor links, only when page has certain elements
  $(document).has(".js-smooth-scroll, .local-navigation .nav").on("click", "a[href*='#']:not([href='#'], [href*='#panel-'])", function() {

    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

      var $target = $(this.hash);
      $target = $target.length ? $target : $('[name=' + this.hash.slice(1) +']');

      if ($target.length) {
        // Get some useful data after the click interaction
        var $offsetClickFromLocalNav = 0,
            $navHeightLocalMenu = 0,
            $navHeightDesktop = 0,
            $offsetHeightNav = 0;

        if ($(".js-float-menu-on-scroll").length)
          var $navHeightLocalMenu = $(".js-float-menu-on-scroll").delay(300).outerHeight();

        if ($("#fixed-header").length)
          var $navHeightDesktop = $("#fixed-header").delay(300).outerHeight();

        // Reset our on-load anchor target helper
        if ($('.js-hashlink').length)
          if ($(".local-navigation .nav").length) {
            $('.js-hashlink').css({'height': '0px', 'margin-top': $offsetHeightExtra+'px'});
          } else {
            $('.js-hashlink').css({'height': '0px', 'margin-top': '0px'});
          }

        // This prevents the anchor target to be overlayed by our floating header
        if ($(this).closest(".local-navigation-wrapper").length)
          $offsetClickFromLocalNav = $navHeightLocalMenu;

        // Define the top offset for our anchor navigation, based on screen size
        if ($(window).width() < $mdScreenWidth) {
          $offsetHeightNav = $navHeightLocalMenu;
        } else {
          $offsetHeightNav = $navHeightDesktop+$offsetClickFromLocalNav;
        }

        // Scroll smoothly to our target
        $('html, body').delay(300).animate({
          scrollTop: ($target.offset().top-$offsetHeightNav)
        }, 500);
        // Keep local anchor navigation in browser history
        history.pushState({}, "", this.href);
        return false;
      }

    }

  });

}(jQuery));
