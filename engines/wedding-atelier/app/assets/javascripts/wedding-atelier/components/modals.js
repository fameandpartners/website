'use strict';

(function () {
  $(document).ready(function () {
    $('#test').bind('click', function () {
      var $modal = $('#modal-moodboard');
      $modal.modal('show');
      $modal.parent().addClass('pos-r');
      $('.modal-backdrop').appendTo('.test-modal');

      $('body').removeClass('modal-open');
      $('body').css('padding-right', '');
    });
  });
})();
