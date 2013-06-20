$(function(){
  $('#custom_dress_color').minicolors({
    inline: true,
    control: 'wheel',
    change: function(hex, opacity) {
      $('#custom_dress_color').val(hex);
      $('#custom-dress-color-pattern').css('background-color', hex);
    }
  });

  $('#custom_dress_required_at').datepicker({
    dateFormat: 'd MM yy'
  });

  $('.custom-dress-image-upload').fileupload({
    url: $('form.custom-dress').attr('action') + '/custom_dress_images.json',
    dataType: 'json',
    formData: {},
    multipart: true,
    paramName: 'custom_dress_image[files][]',
    singleFileUploads: true,
    send: function(e, data) {
      var $loader = $('<div/>').addClass('ajax-loader');
      $(e.target).append($loader);
      $('.photos-upload .errors').html('');

      return true;
    },
    done: function(e, data) {
      var $target = $(e.target);

      $.each(data.result, function(index, item){
        if (!item.serialized_errors) {
          var $thumbnail = $('<img/>').attr('src', item.thumbnail_url);
          $target.html('').append($thumbnail);
        } else {
          $target.find('.ajax-loader').remove();
          $error = $('<li/>').html('File ' + item.file_file_name + ' was not uploaded because ' + item.serialized_errors.join(', '));
          $('.photos-upload .errors').append($error)
        }
      })
    }
  });

  $('#custom-dress-image-upload').fileupload({
    url: $('form.custom-dress').attr('action') + '/custom_dress_images.json',
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
          if ($('.uploaded-photos li:has(img)').length == 5) {
            $('.uploaded-photos li:has(img):first').remove();
            $('.uploaded-photos').append('<li/>');
          }
          $('.uploaded-photos li:not(:has(img)):first').html('').append($thumbnail);
        } else {
          $('.uploaded-photos li:has(.ajax-loader):last').find('.ajax-loader').remove();
          $error = $('<li/>').html('File ' + item.file_file_name + ' was not uploaded because ' + item.serialized_errors.join(', '));
          $('.photos-upload .errors').append($error)
        }
      })
    }
  });

  $('form .size-choser :radio').change(function(event){
    $('form .size-choser li').removeClass('active');
    $(event.target).parents('li:first').addClass('active');
  });

  $('form .size-choser li:has(:radio:checked)').addClass('active');

  function toggleFixedBar(){
    var $bar = $('.fixed-bar');

    if ($(window).scrollTop() > 666 && !$bar.data('visible')) {
      $(window).unbind('scroll', toggleFixedBar);
      $bar.animate({top: 0}, 300, function(){
        $(window).bind('scroll', toggleFixedBar);
        $bar.data('visible', true);
      });
    } else if ($(window).scrollTop() < 666 && $bar.data('visible')) {
      $(window).unbind('scroll', toggleFixedBar);
      $bar.animate({top: '-120px'}, 300, function(){
        $(window).bind('scroll', toggleFixedBar);
        $bar.data('visible', false);
      });
    }
  }

  if ($('body.pages-home').length > 0) {
    $(window).bind('scroll', toggleFixedBar);
  }

  $("#carousel").carouFredSel({
    circular: false,
    infinite: false,
    responsive: true,
    auto  : false,
    scroll: {
      fx: 'slide'
    },
    prev  : { 
      button  : "#carousel-prev",
      key   : "left"
    },
    next  : { 
      button  : "#carousel-next",
      key   : "right"
    },
    pagination  : {
      anchorBuilder: function( nr ) {
        return '<a href="#'+ (nr-1) +'" class="item-'+ (nr-1) +'">'+ (nr-1) +'</a>';
      },
      container: "#carousel-pagination"
    }
  });

  $('#toggle-selectbox').chosen();

});