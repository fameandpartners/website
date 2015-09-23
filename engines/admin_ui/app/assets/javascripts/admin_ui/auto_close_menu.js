$(document).ready(function(){

  // Extends the behaviour from `inspinia.js`
  // Wraps the event and stores the state, ensures that the menu stays closed between navigation
  // engines/inspinia-rails/app/assets/javascripts/inspinia.js :80
  var isClosedKey = 'fame.admin.menu.closed';

  // Hook into the click event and check the state afterwards.
  $('.navbar-minimalize').bind('click', function() {

    setTimeout(function () {
      localStorage.setItem(isClosedKey, $("body").hasClass("mini-navbar"))
    }, 250);
  });

  if ( localStorage.getItem(isClosedKey) == 'true' ) {
    $('a.navbar-minimalize.minimalize-styl-2.btn.btn-primary').click();
  }
});
