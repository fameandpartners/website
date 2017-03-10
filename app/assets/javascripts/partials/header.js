'use strict';
(function ($) {
  function close_menu() {
    $('#home-menu .nav-main-menu span, .rect').removeClass('active');
  }

  function close_search() {
    $('.js-search').removeClass('active');
    $('.nav-main-menu').fadeTo( 100, 1 );
  }

  //Search input trigger
  $('.js-search').on('click', function() {
    close_menu();
    $('.nav-main-menu').fadeTo( 300, 0 );
    $(this).addClass('active');
    $('#searchValue').focus();
  });


  $('.js-search-trigger').on('click', function(e) {
    if ($(this).parent().hasClass('active')) {
      if ($("#searchForm #searchValue").val() !== '') {
        $("#searchForm").submit();
      } else {
        e.stopPropagation();
        close_search();
      }
    }
  });

  //Close search input triggers
  if ($('html').find('.js-search.active')) {
    $('html').click(function(event) {
      if ($(event.target).closest('.js-search').length === 0 || $(event.target).is('span.close-search.btn-close')) {
        close_search();
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
      if ($(event.target).closest('#fixed-header').length === 0) {
        close_menu();
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

  if ($('#locale-warn-bar:visible').length) {
    $( 'header.main' ).addClass('locale-warn-active');
  }

  $('#locale-selector-mobile-container, #locale-selector-current').on('click', function() {
    $(this).toggleClass('show-options');
  });

  $("#side-search-area #side-search-icon").on('click', function() {
    if ($("#side-search-area #searchForm input").val() !== "") {
      $("#side-search-area #searchForm").submit();
    }
  });

})(jQuery);
