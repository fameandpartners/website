'use strict';
(function ($) {

  function slickNavLocalGoTo(responsiveNavLocal) {

    var responsiveNavLocal,
        slick_target_position;
    // Go to target item in local navigation, according to the current anchor
    if (responsiveNavLocal.hasClass('slick-initialized'))
      slick_target_position = $('.local-navigation .nav a').index($('[href="'+window.location.hash+'"]'));
      responsiveNavLocal.slick( "slickGoTo", parseInt( slick_target_position ), false);

  }

  // Get useful data before any interaction
  var sitewideHeaderHeight = 0,
      navLocalMenuHeight = 0,
      localNavTopOffset = 0,
      lastNavLocalItem = $('.js-float-menu-on-scroll .nav a:last').attr('href'), // Get the last section ID
      offsetTargetTopPadding = 70, // The desired distance between the target and the page header
      initialoffsetTargetTopPadding = 570, //the nav does not update for each section until you scroll through half of the category.
      mdScreenWidth = 992,
      smScreenWidth = 768,
      responsiveNavLocal = $('.local-navigation .nav');

  // Set the height of the fixed header
  if ($("#fixed-header").length)
    sitewideHeaderHeight = $("#fixed-header").delay(300).outerHeight();

  // Set the height and offset of the local navigation
  if ($(".local-navigation-wrapper").length) {
    navLocalMenuHeight = $(".local-navigation-wrapper").delay(300).outerHeight();
    localNavTopOffset = $(".local-navigation-wrapper").offset().top; // Desktop only
  }

  var offsetHeight = sitewideHeaderHeight+navLocalMenuHeight;

  // Add DOM helper if we are loading this page directly from an URL containing an anchor (/something#foo=bar)
  // This is needed for our fixed header and floating menu
  if ( window.location.hash ) {
    var hash_var = window.location.hash,
        id   = hash_var.slice(1),
        elem = document.getElementById(id),
        hashlink = '<div id='+id+' class="hashlink js-hashlink"></div>';

    elem.removeAttribute('id');
    elem.insertAdjacentHTML('beforebegin', hashlink);

    // If the URL contains an anchor and a local navigation
    if ($(".local-navigation .nav").length) {
      $('.js-hashlink').css({'height': (offsetHeight-offsetTargetTopPadding)+'px', 'margin-top': -(offsetHeight-offsetTargetTopPadding)+'px'});
    } else {
    // If the URL contains an anchor but not a local navigation
      $('.js-hashlink').css({'height': offsetHeight+'px', 'margin-top': -offsetHeight+'px'});
    }
    window.location.hash = hash_var;
  }

  // Check if we have any floating menu in the page
  if ($('.js-float-menu-on-scroll').length) {

    // Add scrollspy trigger
    // If this is a mobile device we don't worry about the fixed header's height for the top offset
    if ( $(window).width() < mdScreenWidth ) {
      $('body').scrollspy({ target: '.js-float-menu-on-scroll', offset: (initialoffsetTargetTopPadding) })
    } else {
      //Since this is not a mobile device then we have to consider the fixed header in the top offset
      $('body').scrollspy({ target: '.js-float-menu-on-scroll', offset: (((offsetHeight)/2)-offsetTargetTopPadding) })
    }

    // Floating menu as a responsive Carousel
    if (responsiveNavLocal.length) {
      var renderSlick,
          slick_anchor_id = window.location.hash,
          slick_target_position

      renderSlick = function () {
        if (!responsiveNavLocal.hasClass('slick-initialized')) {

          responsiveNavLocal.slick({
            autoplay: false,
            fade: false,
            arrows: true,
            dots: false,
            edgeFriction: 10,
            slidesToScroll: 1,
            slidesToShow: 8,
            infinite: false,
            focusOnSelect: true,
            centerMode: false,
            mobileFirst: false,
            variableWidth: true,
            prevArrow: '<span>◂</span>',
            nextArrow: '<span>▸</span>',
            responsive: [
              {
                breakpoint: mdScreenWidth,
                settings: {
                  centerMode: false,
                  mobileFirst: true,
                  variableWidth: true,
                  slidesToShow: 3
                }
              },
              {
                breakpoint: smScreenWidth,
                settings: {
                  centerMode: true,
                  mobileFirst: true,
                  variableWidth: true,
                  slidesToShow: 3
                }
              }
            ]
          });

          // Go to current nav item
          if (slick_anchor_id) {
            slickNavLocalGoTo(responsiveNavLocal);
          }

        }
      }

      // Render for the first time (on page load)
      renderSlick();

      // Autoplay if user is 2 sections in
      responsiveNavLocal.on('afterChange', function(event, slick, currentSlide){
        if (currentSlide > 1) {
          //$(this).slick("slickSetOption", "autoplay", true);
        } else {
          $(this).slick("slickSetOption", "autoplay", false);
        }
      });

    }

    // Watch scrolling to show/hide floating menu
    if ($(".local-navigation-wrapper").length) {
      $(document).delay(100).on("scroll", function() {

        // Checking if it is a mobile device...
        // Mobile: attach the local menu to the bottom
        if( $(window).width() < mdScreenWidth ) {

          $('.local-navigation-wrapper .js-float-menu-on-scroll').addClass('fixed-nav-mobile').fadeIn(100);
          $('.js-footer').css({'padding-bottom': ''+navLocalMenuHeight*1.1+'px'}); //Add an extra bottom padding in footer (so the the mobile local menu doesn't cover any content)

        } else {

          // It's not a mobile device...

          // Desktop: Detach the local menu from the bottom
          $('.local-navigation-wrapper .js-float-menu-on-scroll.fixed-nav-mobile').removeClass('fixed-nav-mobile');
          $('.js-footer').css({'padding-bottom': ''});

          // Toggle floating menu if window position is below the target element
          var windowPosition = $(window).scrollTop(),
              target_local_navigation = $(".local-navigation-wrapper");

          if (windowPosition+sitewideHeaderHeight >= target_local_navigation.offset().top+navLocalMenuHeight){

            // Attach the local navigation to the fixed header
            if (!$('.js-float-menu-on-scroll.fixed-nav').length) {
              $('.js-float-menu-on-scroll').addClass('fixed-nav').css({'top': ''+sitewideHeaderHeight+'px'}).fadeIn(100);
            }

          } else {

            // Window position is above "target_local_navigation"

            // Detach the local navigation from the fixed header
            if ($('.js-float-menu-on-scroll.fixed-nav').length) {
              $('.js-float-menu-on-scroll').removeClass('fixed-nav').css({'top': ''});
            }

            // The local navigation is not fixed and the screen is above it = Remove the anchor from the URL.
            history.replaceState({}, "", window.location.toString().split("#")[0]);

          }

          // Monitor the screen position to check if it is currently showing the last navigation item
          if (windowPosition+sitewideHeaderHeight >= $(lastNavLocalItem).offset().top+$(lastNavLocalItem).outerHeight()){
            // If the screen goes beneath the last item we remove the anchor from the URL
            history.replaceState({}, "", window.location.toString().split("#")[0]);
          }


        }

      });

      // Monitor window resizing
      $(window).delay(250).on("resize", function() {

        // If we're on mobile add proper styling to the local navigation
        if ( $(window).width() < mdScreenWidth ) {
          $('.js-float-menu-on-scroll').removeClass('fixed-nav').css({'top': ''});
          $('.local-navigation-wrapper .js-float-menu-on-scroll').addClass('fixed-nav-mobile').fadeIn(100);
          $('.js-footer').css({'padding-bottom': ''+navLocalMenuHeight*1.1+'px'}); //Add extra bottom padding in footer (so the the mobile local menu doesn't cover any content)
        }

        // Go to menu item when resize is finished
        clearTimeout(timeout);
        var timeout = setTimeout(function() {
          slickNavLocalGoTo(responsiveNavLocal);
        }, 250);

      });

      // Monitor scrollspy
      $(window).delay(500).on('activate.bs.scrollspy', function(e) {
        // Change the anchor URL according to each seen section
        history.replaceState({}, "", $("a[href^='#']", e.target).attr("href"));

        // Activate the current item in Slick carousel by matching Scrollspy's current response
        slickNavLocalGoTo(responsiveNavLocal);

      });

    }

  }

  // Watch clicks on anchor links (only when page has certain elements)
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
        if( !$('.js-float-menu-on-scroll.fixed-nav').length ) {
          if ($(this).closest(".local-navigation-wrapper").length) {
            offsetClickFromLocalNav = navLocalMenuHeight+offsetTargetTopPadding;
          }
        } else {
          offsetClickFromLocalNav = offsetTargetTopPadding;
        }

        // Define the top offset for our anchor navigation, based on screen size
        if ($(window).width() < mdScreenWidth) {
          offsetNavHeight = offsetClickFromLocalNav;
        } else {
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
