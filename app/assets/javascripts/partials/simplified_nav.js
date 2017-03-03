(function ($) {
  'use strict';
  var $simplifiedNavContainer = $('.js-simplified-nav-container');

  function addHighlightingToMenuIndex(menuIndex){
    $('.nav-main-menu span:eq(' + menuIndex + ')').addClass('active');
  }

  function removeHighlighting(){
    $('.js-open-nav-menu').removeClass('active');
  }

  function removeActive(){
    removeHighlighting();
    $('.nav-menu-contents').closest('.active').removeClass('active');
  }

  function openMenu(menuIndex){
    removeActive(menuIndex);
    addHighlightingToMenuIndex(menuIndex);
    $simplifiedNavContainer.find('.nav-menu-wrap:eq(' + menuIndex + ')').addClass('active');
  }

  // Event triggers
  //Mega menu trigger
  $(".simplified-nav .js-open-nav-menu").on('mouseover', function() {
    openMenu($(this).index());
  });

  // Mouse leaves hit area zone
  $('.simplified-nav-container').on('mouseleave', removeActive);

})(jQuery);
