(function () {

  $(document).ready(function() {
    function addAnother(e) {
      var invitationsCount = $('.js-invitations .js-invitation').length,
          $invitation = $('.js-invitation:last').clone();

      $invitation.find('input').attr('id', 'email_address_' + invitationsCount);
      $('.js-invitations .js-invitation:last')
        .after($invitation);
    }

    $('.js-add-another a').bind('click', addAnother);
  });

})();
