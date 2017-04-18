(function ($) {
  $(document).ready(function () {
    function expand_target_panel(){
      var url = window.location.hash;
      if ( url.match('#') ) {
          var hash = url.split('#')[1];
          try { // User or Callback can give jquery invalid, error selectors
            if ($('#' + hash).length) {
              // activate the requested panel
              $('.active #' + hash + ' .panel-collapse').addClass('in');
              $('.active #' + hash + ' .panel-title').removeClass('collapsed');
            }
          } catch(error) {
            console.warn('Invalid jQuery selector');
          }
      }
    }

    $('body').on('click.collapse-next.data-api', '[data-toggle=collapse-next]', function () {
      var $this   = $(this);
      var $target = $this.parent().next();
      $target.data('bs.collapse') ? $target.collapse('toggle') : $target.collapse();
      $this.toggleClass('collapsed');
    });

    // Watch clicks on <a> tags with "expand-faq" class
    $(document).has(".panel-collapse").on("click", "a.expand-faq", function() {
      // Expand panels
      var target_id = this.hash.slice(1);
      if ($('#'+target_id).length) {
        $('.active #' + target_id + ' .panel-collapse').addClass('in').css('height','');
        $('.active #' + target_id + ' .panel-title').removeClass('collapsed');
      }

    });

    // On page load
    expand_target_panel();
  });

})(jQuery);
