//= require jquery
//= require bootstrap
//= require react
//= require react_ujs
//= require components
//= require select2-4.0.3
//= require bootstrap-datepicker-1.6.4
//= require_tree

$(document).ready(function () {

  $('#test').bind('click', function () {
    $('#modal-assign-dress').modal('show');
    $('.test-modal').addClass('after_append');
    $('.modal-backdrop').appendTo('.test-modal');

    $('body').removeClass('modal-open');
    $('body').css('padding-right', '');
  });

});
