'use strict';

(function() {

  $(document).ready(function () {
    var $customizeDressBtn = $('.js-customize-dress');

    function toggleCustomizationList(e) {
      $('.customization-panel').toggleClass('hidden');
    }
    $customizeDressBtn.bind('click', toggleCustomizationList);
  });

})();
