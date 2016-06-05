$(function() {
  $('body').on('click.collapse-next.data-api', '[data-toggle=collapse-next]', function() {
      $this = $(this);
      var $target = $this.parent().next();
      $this.toggleClass('collapsed');
      $target.data('bs.collapse') ? $target.collapse('toggle') : $target.collapse();
    });
    (function ($) {
      var hash = document.location.hash;
      if (hash) {
        $(hash).addClass('in');
      }
    }(jQuery));
});
