(function ($) {
  $('.js-hero-banner-link').click(function () {
    var link        = $(this);
    var description = link.data('description');
    var value       = $('.js-hero-banner-link').index(link);

    track.event('Banner', 'Click', description, value);
  });
})(jQuery);

