# usage
# initProductCollectionImageHover(
#   selector: '.category .category--item',
# )
window.initProductCollectionImageHover = (options = {}) ->

  $(options.selector).each ->
    $(this).data('original', $(this).attr('src'))
    $('<img/>')[0].src = $(this).data('hover') if $(this).data('hover')
    #(new Image()).src = hoverImageURL if hoverImageURL

  $(options.selector).on 'mouseenter', options.delegate, (e) ->
    if $(this).data('hover')
      $(this).attr('src', $(this).data('hover'))

  $(options.selector).on 'mouseleave', options.delegate, (e) ->
    if $(this).data('original')
      $(this).attr('src', $(this).data('original'))
