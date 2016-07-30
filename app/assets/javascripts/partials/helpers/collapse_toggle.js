(function ($) {

  function expand_target_panel(){
    var url = window.location.hash;
    if ( url.match('#') ) {
        var hash = url.split('#')[1];
        // activate the requested panel
        $('.active #' + hash + ' .panel-collapse').addClass('in');
        $('.active #' + hash + ' .panel-title').removeClass('collapsed');
    }
  }

  $('body').on('click.collapse-next.data-api', '[data-toggle=collapse-next]', function () {
    var $this   = $(this);
    var $target = $this.parent().next();
    $target.data('bs.collapse') ? $target.collapse('toggle') : $target.collapse();
    $this.toggleClass('collapsed');
  });

  // Watch clicks on anchor links
  $(document).has(".panel-collapse").on("click", "a[href*='#']:not([href='#'], [href*='#panel-'], [data-toggle=collapse-next])", function() {
    // Expand/Collapse panels
    $('.active #' + this.hash.slice(1) + ' .panel-collapse').addClass('in').css('height','');
    $('.active #' + this.hash.slice(1) + ' .panel-title').removeClass('collapsed');
  });

  // On page load
  expand_target_panel();

})(jQuery);
