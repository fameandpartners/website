'use strict';

(function() {
  $(document).ready(function () {
    $('#notifications .notification-close').on('click', function () {
      $(this).parent().hide();
    });
  });
}());
