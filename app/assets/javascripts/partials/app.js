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



  window.initHoverableProductImages()

  $("abbr.timeago").timeago();

  //track.remarketing_tag()
});

$('body.blog').ready(function(){
  track.conversion('blog_view')
});

$('.ecommerce').ready(function(){
  $(document).on('click', '.ask-parent-to-pay-button', function(e){
    e.preventDefault();
    paymentRequestModal.show();
    if (window.shoppingBag) window.shoppingBag.hide();
  });
});


$(function() {
  $('.selectbox').chosen({
    width: '100%',
    disable_search: true
  });

  $('.current-version').on('click', function() {
    $(this).toggleClass('active');
    $('.site-version-switch ul').toggle();
  });

  $('.dropdown-trigger').hover(
    function() {
      $(this).find('.dropdown-menu').stop(true, true).fadeIn('fast');
    },
    function() {
      $(this).find('.dropdown-menu').stop(true, true).fadeOut('fast');
    }
  );

  $('.shopping-bag').on('click', function() {
    $(this).siblings('.shopping-bag-popup').toggle();
    return false
  });



  // blog
  if ($('.blog-header').length) {
    $('.toggle-search').on('click', function(){
      $('.blog-header .search').toggle();
      return false
    });
  }


  // blog carousel
  // generate custom carousel pager
  $blogCarouselBox = $('.blog-carousel');
  $blogCarousel = $blogCarouselBox.find('.carousel');
  pagerStr = '';
  $blogCarouselPager = $blogCarouselBox.find('.controls').find('.pager')
  for (var i = 0; i < $blogCarousel.find('li').length; i++ ) 
    pagerStr += '<a href="#" data-slide-index="'+i+'"></a>'
  $blogCarouselPager.html(pagerStr);

  // init carousel
  $blogCarousel.bxSlider({
    minSlides: 3,
    maxSlides: 3,
    slideWidth: 460,
    slideMargin: 5,
    moveSlides: 1,
    pagerCustom:  '.blog-carousel .pager',
    nextSelector: '.blog-carousel .next',
    prevSelector: '.blog-carousel .prev',
    onSlideAfter: function($slideElement, oldIndex, newIndex) {
      $slideElement.addClass('current').siblings('li').removeClass('current next-slide prev-slide');
      $slideElement.removeClass('next-slide').next().addClass('next-slide');
      $slideElement.removeClass('prev-slide').prev().addClass('prev-slide');
    }
  });

});

