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
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic

$(function(){
  $('#custom-dress-image-upload').fileupload({
    url: '/custom_dress_images.json',
    dataType: 'json',
    formData: {},
    multipart: true,
    paramName: 'custom_dress_image[files][]',
    singleFileUploads: false,
    limitMultiFileUploads: 5,
    send: function(e, data) {
      $('.photos-upload .errors').html('');

      for (var i = 0; i < data.files.length; i++) {
        var $loader = $('<div/>').addClass('ajax-loader');
        $('.uploaded-photos li:not(:has(img, .ajax-loader)):first').append($loader);
      }

      return true;
    },
    done: function(e, data) {
      $.each(data.result, function(index, item){
        if (!item.serialized_errors) {
          var $thumbnail = $('<img/>').attr('src', item.thumbnail_url)
          var $field = $('<input/>').attr('type', 'hidden')
            .attr('name', 'custom_dress[custom_dress_image_ids][]')
            .attr('value', item.id);
          if ($('.uploaded-photos li:has(img)').length == 5) {
            $('.uploaded-photos li:has(img):first').remove();
            $('.uploaded-photos').append('<li/>');
          }
          $('.uploaded-photos li:not(:has(img)):first').html('').append($thumbnail).append($field);
        } else {
          $('.uploaded-photos li:has(.ajax-loader):last').find('.ajax-loader').remove();
          $error = $('<li/>').html('File ' + item.file_file_name + ' was not uploaded because ' + item.serialized_errors.join(', '));
          $('.photos-upload .errors').append($error)
        }
      })
    }
  });

  $('form li.color a').click(function(event){
    event.preventDefault();
    var $target = $(event.target);
    $target.parent('.color').siblings().find(':checkbox').attr('checked', false);
    $target.find(':checkbox').attr('checked', true);
    $target.parent().addClass('active').siblings().removeClass('active');
  });

  $('form li.color:has(:checkbox:checked)').addClass('active');

  function toggleFixedBar(){
    var $bar = $('.fixed-bar');

    if ($(window).scrollTop() > 666 && !$bar.data('visible')) {
      $(window).unbind('scroll', toggleFixedBar);
      $bar.animate({top: 0}, 500, function(){
        $(window).bind('scroll', toggleFixedBar);
        $bar.data('visible', true);
      });
    } else if ($(window).scrollTop() < 666 && $bar.data('visible')) {
      $(window).unbind('scroll', toggleFixedBar);
      $bar.animate({top: '-120px'}, 500, function(){
        $(window).bind('scroll', toggleFixedBar);
        $bar.data('visible', false);
      });
    }
  }

  if ($('body.pages-home').length > 0) {
    $(window).bind('scroll', toggleFixedBar);
  }
});
