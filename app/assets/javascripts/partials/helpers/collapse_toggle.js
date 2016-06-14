(function ($) {
  $('body').on('click.collapse-next.data-api', '[data-toggle=collapse-next]', function () {
    var $this   = $(this);
    var $target = $this.parent().next();
    $this.toggleClass('collapsed');
    $target.data('bs.collapse') ? $target.collapse('toggle') : $target.collapse();
  });

  var hash = document.location.hash;
  if (hash) {
    $(hash).addClass('in');
  }
})(jQuery);
