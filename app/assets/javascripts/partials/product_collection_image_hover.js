// deprecated; all logic moved to libs/jquery.hoverable.js
//   it's easier to call $('').hoverable() without params
//
// usage
// initProductCollectionImageHover(
//   selector: '.category .category--item',
//   delegate: '.img-product'
// )
//
// note: don't call it twice
window.initProductCollectionImageHover = function(options) {

  if (options == null) { options = {}; }
  $(options.selector).find(options.delegate).each(function() {
    // Image preload only works on products on first page load,
    // AJAX ones are not loaded due to dynamic DOM.
    if ($(this).data('hover')) { return $('<img/>')[0].src = $(this).data('hover'); }
  });

  $(options.selector).on('mouseenter', options.delegate, function(e) {
    e.preventDefault();
    let $this = $(this);
    if ($this.data('hover')) {
      let src = $this.data('hover');
      return $this.attr('src', src);
    }
  });

  return $(options.selector).on('mouseleave', options.delegate, function(e) {
    e.preventDefault();
    let $this = $(this);
    if ($this.data('original')) {
      let src = $this.data('original');
      return $this.attr('src', src);
    }
  });
};


