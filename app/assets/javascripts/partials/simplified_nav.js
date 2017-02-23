'use strict';
(function ($) {
  var $simplifiedNav = $('.js-simplified-nav');
  var $search = $('.js-search');

  function closeMenu() {
    $simplifiedNav.find('.nav-main-menu span, .rect').removeClass('active');
  }

  // ****** SEARCH FUNCTIONALITY ******
  // // TODO: Does not belong in simplified_nav
  // function close_search() {
  //   $search.removeClass('active');
  //   $('.nav-main-menu').fadeTo( 100, 1 );
  // }

  // // TODO: Does not belong in simplified_nav
  //Search input trigger
  // $search.on('click', function() {
  //   closeMenu();
  //   $('.nav-main-menu').fadeTo( 300, 0 );
  //   $(this).addClass('active');
  //   $('#searchValue').focus();
  // });
  // $('.js-search-trigger').on('click', function(e) {
  //   if ($(this).parent().hasClass('active')) {
  //     if ($("#searchForm #searchValue").val() !== '') {
  //       $("#searchForm").submit();
  //     } else {
  //       e.stopPropagation();
  //       close_search();
  //     }
  //   }
  // });

  // //Close search input triggers
  // if ($('html').find('#search.active')) {
  //   $('html').click(function(event) {
  //     if ($(event.target).closest('#search').length === 0 || $(event.target).is('span.close-search.btn-close')) {
  //       close_search();
  //     }
  //   });
  // }

  function removeActive(menuIndex){
    $('simplified-nav');
    if ($('html').find('.rect.active')) {
      $(".nav-main-menu span:not(':eq(" + menuIndex + ")'), .rect-wrapper .rect:not(':eq(" + menuIndex + ")')").removeClass('active');
    }
    $(".nav-main-menu span:eq(" + menuIndex + "), .rect-wrapper .rect:eq(" + menuIndex + ")").removeClass('active');
  }

  function toggleActive(menuIndex){
    if ($('html').find('.rect.active')) {
      $(".nav-main-menu span:not(':eq(" + menuIndex + ")'), .rect-wrapper .rect:not(':eq(" + menuIndex + ")')").removeClass('active');
    }
    $(".nav-main-menu span:eq(" + menuIndex + "), .rect-wrapper .rect:eq(" + menuIndex + ")").toggleClass('active');
  }

  function addActive(menuIndex){
    if ($('html').find('.rect.active')) {
      $(".nav-main-menu span:not(':eq(" + menuIndex + ")'), .rect-wrapper .rect:not(':eq(" + menuIndex + ")')").removeClass('active');
    }
    $(".nav-main-menu span:eq(" + menuIndex + "), .rect-wrapper .rect:eq(" + menuIndex + ")").addClass('active');
  }

  //Mega menu trigger
  $(".nav-main-menu .js-open-nav-menu").on('mouseover', function() {
    var menuIndex = $(this).index();
    addActive(menuIndex);
  });

  // Mouse leaves hit area zone
  $('.simplified-nav-container').on('mouseleave', function() {
    $('.nav-menu-contents').closest('.active').removeClass('active');
  });

  //Check if any mega menu is open
  if ($('html').find('.rect.active')) {

    //Close mega menu when clicked beneath it
    $('html').click(function(event) {
      if ($(event.target).closest('#fixed-header').length === 0) {
        closeMenu();
      }
    });

  }

  //My account area trigger
  // $("#account-area .my-account").mouseenter(function() {
  //   $("#account-area .account-menu").show();
  // });
  // $("#account-area .account-menu").mouseleave(function() {
  //   $("#account-area .account-menu").hide();
  // });

  //Lookbook slide
  // var lookbook_slide;
  // lookbook_slide = $(".lookbook-slide");
  // if (lookbook_slide.length) {
  //   return lookbook_slide.responsiveSlides({
  //     auto: false,
  //     nav: true
  //   });
  // }

  // if ($('#locale-warn-bar:visible').length) {
  //   $( 'header.main' ).addClass('locale-warn-active');
  // }
  //
  // $('#locale-selector-mobile-container, #locale-selector-current').on('click', function() {
  //   $(this).toggleClass('show-options');
  // });

  // $("#side-search-area #side-search-icon").on('click', function() {
  //   if ($("#side-search-area #searchForm input").val() !== "") {
  //     $("#side-search-area #searchForm").submit();
  //   }
  // });

})(jQuery);
