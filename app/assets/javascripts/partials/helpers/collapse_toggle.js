(function ($) {

  $('body').on('click.collapse-next.data-api', '[data-toggle=collapse-next]', function () {
    var $this   = $(this);
    var $target = $this.parent().next();
    $this.toggleClass('collapsed');
    $target.data('bs.collapse') ? $target.collapse('toggle') : $target.collapse();
  });

  var url = window.location.hash;
  if ( url.match('#') ) {
      var hash = url.split('#')[1];
      // activate the requested panel
      $('#' + hash + ' .panel-collapse').addClass('in');
      $('#' + hash + ' .panel-title').removeClass('collapsed')
  }

})(jQuery);
