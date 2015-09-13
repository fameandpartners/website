'use strict';
// TODO: re-do tabs in vanilla
(function ($) {

  var $tabs = $('.js-tabs-home-collection li');

  $('.js-tabs-home-collection a').on('click', function(e) {
    e.preventDefault();
    $(this).tab('show');
  });

  $('.js-navigator-prev').on('click', function() {
      $tabs.filter('.active').prev('li').find('a[data-toggle="tab"]').tab('show');
  });

  $('.js-navigator-next').on('click', function() {
      $tabs.filter('.active').next('li').find('a[data-toggle="tab"]').tab('show');
  });

}(jQuery));