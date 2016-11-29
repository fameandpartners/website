// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require libs/underscore-min
//= require inspinia-rails
//= require jquery-ui
//= require chosen-jquery
//= require select2

//= require react
//= require react_ujs
//= require components

//
// Manual Orders
//
//= require manual_order

//= require_tree .

$(document).ready(function(){
  $('[data-confirm]').click(function(e){
    var confirmation_message = $(e.target).data('confirm');
    var confirmed = confirm(confirmation_message);

    if (!confirmed) { e.preventDefault() }
  })
});
