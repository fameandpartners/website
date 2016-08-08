'use strict';
(function ($) {

  // Get useful data before any interaction
  var sitewideHeaderHeight = 0,
      navLocalMenuHeight = 0,
      localNavTopOffset = 0,
      offsetHeight = sitewideHeaderHeight+navLocalMenuHeight,
      offsetTargetTopPadding = 45, // The desired distance between the target and the page header
      mdScreenWidth = 992,
      responsiveNavLocal = $('.local-navigation .nav');

  if ($("#fixed-header").length)
    sitewideHeaderHeight = $("#fixed-header").delay(300).outerHeight();

  if ($(".js-float-menu-on-scroll").length)
    navLocalMenuHeight = $(".js-float-menu-on-scroll").delay(300).outerHeight();

  if ($(".local-navigation-wrapper .js-float-menu-on-scroll").length)
    localNavTopOffset = $(".local-navigation-wrapper .js-float-menu-on-scroll").offset().top; // Desktop only

  // Add DOM helper if we are loading this page directly from an URL containing an anchor (/something#foo=bar)
  // This is needed for our fixed header and floating menu
  if ( window.location.hash ) {
    var hash_var = window.location.hash,
        id   = hash_var.slice(1),
        elem = document.getElementById(id),
        hashlink = '<div id='+id+' class="hashlink js-hashlink"></div>';

    elem.removeAttribute('id');
    elem.insertAdjacentHTML('beforebegin', hashlink);
    if ($(".local-navigation .nav").length) {
      $('.js-hashlink').css({'height': (offsetHeight-offsetTargetTopPadding)+'px', 'margin-top': -(offsetHeight-offsetTargetTopPadding)+'px'});
    } else {
      $('.js-hashlink').css({'height': offsetHeight+'px', 'margin-top': -offsetHeight+'px'});
    }
    window.location.hash = hash_var;
  }

  // Check if we have any floating menu in the page
  if ($('.js-float-menu-on-scroll').length) {

    // Add scrollspy trigger
    // If this is a mobile device we don't worry about the fixed header's height for the top offset
    if( $(window).width() <= mdScreenWidth ) {
      $('body').scrollspy({ target: '.js-float-menu-on-scroll', offset: (offsetTargetTopPadding) })
    } else {
      //Since this is not a mobile device then we have to consider the fixed header in the top offset
      $('body').scrollspy({ target: '.js-float-menu-on-scroll', offset: (offsetHeight+offsetTargetTopPadding) })
    }

    // Floating menu as a responsive Carousel
    if (responsiveNavLocal.length) {
      var renderSlick,
          slick_anchor_id = window.location.hash,
          slick_target_position

      renderSlick = function () {
        if(!responsiveNavLocal.hasClass('slick-initialized')) {

          responsiveNavLocal.slick({
            autoplay: false,
            fade: false,
            arrows: true,
            dots: false,
            edgeFriction: 10,
            slidesToScroll: 1,
            slidesToShow: 5,
            variableWidth: true,
            infinite: false,
            focusOnSelect: true,
            centerMode: false,
            mobileFirst: true,
            responsive: [
              {
                breakpoint: mdScreenWidth,
                settings: {
                  centerMode: true,
                  slidesToShow: 3
                }
              }]
          });

          if (slick_anchor_id) {
            slick_target_position = $('.local-navigation .nav a').index($('[href="'+slick_anchor_id+'"]'));
            responsiveNavLocal.slick( "slickGoTo", parseInt( slick_target_position ), true ).fadeIn(250);
          }

        }
      }

      // Render for the first time (on page load)
      renderSlick();
    }

    // Watch scrolling to show/hide floating menu
    $(document).delay(500).on("scroll", function() {

      // Checking if it is a mobile device...
      // Mobile: attach the local menu to the bottom
      if( $(".local-navigation-wrapper .local-navigation").css('position') == 'fixed' ) {

        $('.local-navigation-wrapper .js-float-menu-on-scroll').addClass('fixed-nav-mobile').fadeIn(100);
        $('.js-footer').css({'padding-bottom': ''+navLocalMenuHeight*1.1+'px'}); //Add an extra bottom padding in footer (so the the mobile local menu doesn't cover any content)

      } else {

        // It's not a mobile device...

        // Detach the local menu from the bottom
        $('.local-navigation-wrapper .js-float-menu-on-scroll.fixed-nav-mobile').removeClass('fixed-nav-mobile').fadeOut(100);
        $('.js-footer').css({'padding-bottom': ''});

        // Attach the local navigation to the fixed header
        // Toggle floating menu if window position is below the target element
        var windowPosition = $(window).scrollTop(),
            target_local_navigation = $(".local-navigation-wrapper");

        if (windowPosition+sitewideHeaderHeight >= target_local_navigation.offset().top+navLocalMenuHeight){
          if ($('.js-float-menu-on-scroll.fixed-nav').length) {
            $('.js-float-menu-on-scroll.fixed-nav').fadeIn(100);
          } else {
            $('.local-navigation-wrapper .js-float-menu-on-scroll').clone().appendTo('#fixed-header').addClass('fixed-nav').fadeIn(100);
          }
        } else {
          // Window position is above "target_local_navigation"
          if ($('.js-float-menu-on-scroll.fixed-nav').length)
            $('.js-float-menu-on-scroll.fixed-nav').fadeOut(300);
        }

      }

    });

  }

  // Watch clicks on anchor links, only when page has certain elements
  $(document).has(".js-smooth-scroll, .local-navigation .nav").on("click", "a[href*='#']:not([href='#'], [href*='#panel-'])", function() {

    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');

      if (target.length) {
        // Get some useful data after the click interaction
        var offsetClickFromLocalNav = 0,
            navLocalMenuHeight = 0,
            sitewideHeaderHeight = 0,
            offsetNavHeight = 0;

        if ($(".js-float-menu-on-scroll").length)
          navLocalMenuHeight = $(".js-float-menu-on-scroll").delay(300).outerHeight();

        if ($("#fixed-header").length)
          sitewideHeaderHeight = $("#fixed-header").delay(300).outerHeight();

        // Reset our on-page-load anchor target helper
        if ($('.js-hashlink').length)
          if ($(".local-navigation .nav").length) {
            $('.js-hashlink').css({'height': '0px', 'margin-top': offsetTargetTopPadding+'px'});
          } else {
            $('.js-hashlink').css({'height': '0px', 'margin-top': '0px'});
          }

        // This prevents the anchor target to be covered by our fixed header
        if ($(this).closest(".local-navigation-wrapper").length)
          offsetClickFromLocalNav = navLocalMenuHeight;

        // Define the top offset for our anchor navigation, based on screen size
        if ($(window).width() > mdScreenWidth) {
          offsetNavHeight = sitewideHeaderHeight+offsetClickFromLocalNav;
        }

        // Scroll smoothly to our target
        $('html, body').animate({
          scrollTop: (target.offset().top-offsetNavHeight)
        }, 250);
        // Keep local anchor navigation in browser history
        history.pushState({}, "", this.href);
        return false;
      }

    }

  });

}(jQuery));
