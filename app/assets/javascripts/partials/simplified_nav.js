(function ($) {
  'use strict';
  var $simplifiedNavContainer = $('.js-simplified-nav-container');
  function isGAAvailable() {
    return typeof window === 'object' && !!window.ga;
  }
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
    if(isGAAvailable()) {
      window.ga('send', 'event', { 
        eventCategory: 'Top Nav', 
        eventAction: 'Main Nav Press', 
        eventLabel: menuText, 
        nonInteraction: false 
      });
    }
    else {
      console.log("Google analytics not found")
    }
    openMenu($(this).index());
  });
  $simplifiedNavContainer.find('.js-close-nav-menu').on('mouseover', function() {
    removeActive();
  });

  // Mouse leaves hit area zone
  $simplifiedNavContainer.on('mouseleave', removeActive);

})(jQuery);
