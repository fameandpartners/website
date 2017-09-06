(function($) {
  'use strict';

  $().ready(function() {
    var floatingEmailSelector = $(".FloatingEmailWrapper"),
        floatingEmailRowHeight = floatingEmailSelector.outerHeight(), // The height of our email box component
        pageHeight = ($(".contentful-container").outerHeight() - floatingEmailRowHeight), // The total height of our page, minus the floating email row itself
        showFloatingEmailTriggerPercentage = parseInt(floatingEmailSelector.attr('data-showAfterPagePercentage'))/100, // Show floating email box when user scrolls at least 55% of the page
        showFloatingEmailTriggerPixels = (pageHeight*showFloatingEmailTriggerPercentage);

    $('.js-FloatingEmailClose').click(function() {
      floatingEmailSelector.remove();
    });

    if (floatingEmailSelector.length) { // Check if we have the floating email component in the current page
      $(window).on( 'scroll', function(){ // Monitor page scrolling
        if ( $(window).scrollTop() >= showFloatingEmailTriggerPixels) {
          $(".js-footer").css('padding-bottom', floatingEmailRowHeight+'px');
          floatingEmailSelector.addClass("FloatingEmailWrapper--is-active");
        } else {
          $(".js-footer").css('padding-bottom', 'initial');
          floatingEmailSelector.removeClass("FloatingEmailWrapper--is-active");
        }
      });
    }
  });

})(jQuery)
