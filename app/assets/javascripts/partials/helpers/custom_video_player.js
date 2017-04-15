(function ($) {

  $(".custom-video-player-wrapper").click(function () {

    var vid = $(this).children("video").get(0),
        controlBtn = $(this).children(".btn-play-pause");

    if (vid.paused) {
      vid.play();
      controlBtn.hide();
    } else {
      vid.pause();
      controlBtn.show();
    }

    vid.onended = function(e) {
      controlBtn.show();
    }

  });

})(jQuery);
