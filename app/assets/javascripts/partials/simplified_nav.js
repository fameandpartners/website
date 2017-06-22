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
    removeActive();
    addHighlightingToMenuIndex(menuIndex);
    $simplifiedNavContainer.find('.nav-menu-wrap:eq(' + menuIndex + ')').addClass('active');
  }

  // Event triggers
  //Mega menu trigger
  $simplifiedNavContainer.find('.js-open-nav-menu').on('mouseover', function() {
    var menuText = $(this).text().trim().toUpperCase();
    window.ga('send', 'event', { 
      eventCategory: 'Top Nav', 
      eventAction: 'Main Nav Press', 
      eventLabel: menuText, 
      nonInteraction: false 
    });
    openMenu($(this).index());
  });
  $simplifiedNavContainer.find('.js-close-nav-menu').on('mouseover', function() {
    removeActive();
  });

  // Mouse leaves hit area zone
  $simplifiedNavContainer.on('mouseleave', removeActive);

})(jQuery);
