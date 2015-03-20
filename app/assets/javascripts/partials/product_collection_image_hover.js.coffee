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
    $(this).data('original', $(this).attr('src'))
    $('<img/>')[0].src = $(this).data('hover') if $(this).data('hover')

  $(options.selector).on 'mouseenter', options.delegate, (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('hover')
      src = $this.data('hover')
      $this.fadeTo(200, 0.40, -> $this.attr('src', src)).fadeTo(300, 1)

  $(options.selector).on 'mouseleave', options.delegate, (e) ->
    e.preventDefault()
    $this = $(this)
    if $this.data('original')
      src = $this.data('original')
      $this.fadeTo(200, 0.40, -> $this.attr('src', src)).fadeTo(300, 1)


