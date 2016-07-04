'use strict';
(function ($) {

  //Search input trigger
  $("#search").on('click', function() {
    $('.nav-main-menu').fadeTo( "slow", 0.1 );
    $(this).addClass('active');
  });
  $('.js-search-trigger').on('click', function(e) {
    if ($(this).parent().hasClass('active')) {
      if ($("#searchForm #searchValue").val() !== '') {
        $("#searchForm").submit();
      } else {
        e.stopPropagation();
        $("#search").removeClass('active');
        $('.nav-main-menu').fadeTo( "slow", 1 );
      }
    }
  });

  //Close search input if clicked outside
  if ($('html').find('#search.active')) {
    $('html').click(function(event) {
      if ($(event.target).closest('#search').length === 0) {
        $('#search').removeClass('active');
        $('.nav-main-menu').fadeTo( "slow", 1 );
      }
    });
  }

  //Mega menu trigger
  $(".nav-main-menu .js-open-nav-menu").on('click', function() {
    var menu_index;
    menu_index = $(this).index();

    // Toggle when clicked
    if ($('html').find('.rect.active')) {
      $(".nav-main-menu span:not(':eq(" + menu_index + ")'), .rect-wrapper .rect:not(':eq(" + menu_index + ")')").removeClass('active');
    }
    $(".nav-main-menu span:eq(" + menu_index + "), .rect-wrapper .rect:eq(" + menu_index + ")").toggleClass('active');

  });

  //Check if any mega menu is open
  if ($('html').find('.rect.active')) {

    //Close mega menu when clicked beneath it
    $('html').click(function(event) {
    var close_menu;
    close_menu = '#home-menu .nav-main-menu span, .rect';
      if ($(event.target).closest('#fixed-header').length === 0) {
        $(close_menu).removeClass('active');
      }
    });

  }

  //My account area trigger
  $("#account-area .my-account").mouseenter(function() {
    $("#account-area .account-menu").show();
  });
  $("#account-area .account-menu").mouseleave(function() {
    $("#account-area .account-menu").hide();
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

})(jQuery);
