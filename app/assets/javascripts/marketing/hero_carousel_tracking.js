(function ($) {
  $(document).on('click', '.js-hero-banner-link', function () {
    var link        = $(this);
    var description = link.data('description');
    var value       = $('.js-hero-banner-link').index(link);

    track.event('Banner', 'Click', description, value);
  });
})(jQuery);

