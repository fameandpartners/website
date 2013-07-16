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

  $('a.show-style-quiz').bind('click', function(event){
    event.preventDefault();
    event.stopPropagation();

    showStyleQuiz();
    bindStyleQuizEvents();
  });

  window.showStyleQuiz = function(){
    $('.quiz-box').show();
    $('body').css('overflow', 'hidden');
    $.getScript('/quiz');
  }

  window.hideStyleQuiz = function(){
    $('.quiz-box').hide();
    $('body').css('overflow', 'auto');
  }

  window.bindStyleQuizEvents = function(){
    $('.quiz-box').bind('click', function(event){
      event.stopPropagation();
    });

    $(document).keyup(function(event){
      if (event.which == 27) {
        $(document).unbind('keyup');
        $('#wrap').unbind('click');
        hideStyleQuiz();
      }
    });
    $('#wrap').bind('click', function(event){
      $('#wrap').unbind('click');
      $(document).unbind('keyup');
      hideStyleQuiz();
    });
  }

  $('.quiz-box .film-frame').find(':checkbox, :radio').bind('change', function(event){
    var $form = $(event.target).parents('form');

    $form.find('li:not(:has(:input:checked))').removeClass('active');
    $form.find('li:has(:input:checked)').addClass('active');
  });
});
