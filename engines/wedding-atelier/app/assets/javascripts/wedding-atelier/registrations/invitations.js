(function () {

  $(document).ready(function() {
    var $invitation = $('.js-invitation:last').clone();
    $invitation.find('label').remove();
    $invitation.find('input').val('');

    function addAnother(e) {
      $('.js-invitations>.js-invitation:last')
        .after($invitation.clone());
    }

    $('.js-add-another a').bind('click', addAnother);
  });

})();
