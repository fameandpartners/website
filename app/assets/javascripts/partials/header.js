'use strict';
(function ($) {

  //Search input trigger
  $("#search").on('click', function() {
    return $(this).addClass('active');
  });
  $('.js-search-trigger').on('click', function(e) {
    if ($(this).parent().hasClass('active')) {
      if ($("#searchForm #searchValue").val() !== '') {
        return $("#searchForm").submit();
      } else {
        e.stopPropagation();
        return $("#search").removeClass('active');
      }
    }
  });

  //Mega menu trigger
  $("#home-menu .nav-main-menu span.js-open-nav-menu").on('click', function() {
    var menu_index;
    $("#home-menu .nav-main-menu span, .rect, #search").removeClass('active');
    menu_index = $(this).index();
    return $(".nav-main-menu span:eq(" + menu_index + "), .rect-wrapper .rect:eq(" + menu_index + ")").addClass('active');
  });

  //Triggers to close current mega menu
  if ($('html').find('.rect.active')) {
    var close_menu;
    close_menu = '#home-menu .nav-main-menu span, .rect';

    //Close mega menu when cursor is outside for too long
    $('.rect-wrapper, .nav-menu-container').on('mouseleave', function(e) {
      if (!($('.rect-wrapper').has(e.relatedTarget).length)) {
        setTimeout((function() {
          return $("" + close_menu + "").removeClass('active');
        }), 5000);
      }
    });

    //Close mega menu when clicked outside
    $('html').click(function(event) {
      if ($(event.target).hasClass('js-close-nav-menu') || !($('.rect-wrapper .rect').has(event.target).length || $(event.target).hasClass('active'))) {
        return $("" + close_menu + "").removeClass('active');
      }
    });
  }

  //My account area trigger
  $("#account-area .my-account").mouseenter(function() {
    return $("#account-area .account-menu").show();
  });
  $("#account-area .account-menu").mouseleave(function() {
    return $("#account-area .account-menu").hide();
  });

  //Lookbook slide
  var lookbook_slide;
  lookbook_slide = $(".lookbook-slide");
  if (lookbook_slide.length) {
    return lookbook_slide.responsiveSlides({
      auto: false,
      nav: true
    });
  }

  // Fixed Navbar during scroll
  $(window).scroll(function() {
    var scrollTop = $(window).scrollTop();
    var topMargin = 110;
    $(".nav-menu.nav-alert-top").css("top", scrollTop + "px");
      if (scrollTop > topMargin) {
        $("#fixed-header").css("top", scrollTop - topMargin + "px");
      } else {
        $("#fixed-header").css("top", "0px");
      }
  });

})(jQuery);
