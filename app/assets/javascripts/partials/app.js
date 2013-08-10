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
    url: $('#custom-dress-image-upload').data('url'),
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
    url: $('#custom-dress-image-upload').data('url'),
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

  $(".promo-badge").delay(500).fadeIn('slow');

  $('#toggle-selectbox').chosen();

  $('.selectbox').chosen();

  $('.toggle-sizes').fancybox({
    width: '1000',
    height: '183'
  });

  deskTimerCheck = function () {
    if ($('#assistly-widget-1 .a-desk-widget-chat').length) {
      $("#assistly-widget-1 .a-desk-widget-chat")
        .html("Live Chat")
        .css("background-image", "none")
        .on('click', function() { window.track.conversion('live_chat'); return true });
    } else {
      setTimeout(deskTimerCheck, 1000);
    }
  };
  deskTimerCheck();

  window.initHoverableProductImages()

  //track.remarketing_tag()
});

$('body.blog').ready(function(){
  track.conversion('blog_view')
});
