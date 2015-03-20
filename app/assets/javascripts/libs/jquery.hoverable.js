/*
 *	jQuery hoverable 0.0.1
 *
 *	Copyright (c) 2015 Fame&Partners
 *	http://fameandpartners.com/
 *
 *	Dual licensed under the MIT and GPL licenses.
 *	http://en.wikipedia.org/wiki/MIT_License
 *	http://en.wikipedia.org/wiki/GNU_General_Public_License
 */
(function ($) {
  /*
   options : {
     delegate : 200 // animation duration
   }
   */
  $.fn.hoverable = function (opts) {
		var options = $.extend({
      delegate: '.img-product',
      duration: 200
		}, opts);

    return this.each(function() {
      init($(this), options);
      return
    });
  };

  // init element
	function init($element, options){
    if ($element.data('original')){
      // already initialized
      return true;
    };
    $element.data('original', $element.attr('src'));

    if ($element.data('hover')){
      var img = new Image;

      img.onload = function() {
        // prevent double apply
        $element.off('mouseenter', showHoverImage);
        $element.on('mouseenter', showHoverImage);

        $element.off('mouseleave', showOriginalImage);
        $element.on('mouseleave', showOriginalImage);
      };

      img.src = $element.attr('src');
    };

    return
  };

  function showHoverImage(e){
    var $element = $(e.currentTarget);
    var src = $element.data('hover');
    if (src){
      $element.fadeTo(200, 0.40, function(){ $element.attr('src', src); }).fadeTo(300, 1);
    };
    return true;
  };

  function showOriginalImage(e) {
    var $element = $(e.currentTarget);
    var src = $element.data('original');
    if (src){
      $element.fadeTo(200, 0.40, function() { $element.attr('src', src); }).fadeTo(300, 1);
    };
  };
})(jQuery);
