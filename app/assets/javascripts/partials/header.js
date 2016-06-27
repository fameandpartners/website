'use strict';
(function ($) {

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
