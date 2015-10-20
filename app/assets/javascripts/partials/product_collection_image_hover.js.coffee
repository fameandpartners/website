# deprecated; all logic moved to libs/jquery.hoverable.js
#   it's easier to call $('').hoverable() without params
#
# usage
# initProductCollectionImageHover(
#   selector: '.category .category--item',
#   delegate: '.img-product'
# )
#
# note: don't call it twice
window.initProductCollectionImageHover = (options = {}) ->

  $(options.selector).find(options.delegate).each ->
    # Image preload only works on products on first page load,
    # AJAX ones are not loaded due to dynamic DOM.
    $('<img/>')[0].src = $(this).data('hover') if $(this).data('hover')

  $(options.selector).on 'mouseenter', options.delegate, (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('hover')
      src = $this.data('hover')
      $this.attr('src', src)

  $(options.selector).on 'mouseleave', options.delegate, (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('original')
      src = $this.data('original')
      $this.attr('src', src)


