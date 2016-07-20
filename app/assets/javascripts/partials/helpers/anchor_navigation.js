$(function() {

  $('a[href*="#"]:not([href="#"])').click(function() {

    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');

      if (target.length) {

        // Get the Desktop fixed header's height
        var navHeightDesktop = $("#fixed-header").outerHeight();
        var navHeightPageNavigation = $(".js-float-on-scroll").outerHeight();

        $('html, body').animate({
          scrollTop: (target.offset().top-navHeightDesktop-navHeightPageNavigation)
        }, 1000);
        history.pushState({}, "", this.href);
        return false;

      }

    }

  });

});
