$('.index.show, .products.index').ready ->
  imageNotLoadedHandler = (e) ->
    e.preventDefault()
    $image = $(e.currentTarget)
    # avoiding cycling if no alt image can be loaded
    $image.off('error', imageNotLoadedHandler)

    no_image_src = "/assets/" + $image.attr('alt_image')
    $image.attr('src', no_image_src).removeAttr('onmouseover').removeAttr('onmouseout')

  window.addSwitcherToAltImage = () ->
    $('img[alt_image]').on('error', imageNotLoadedHandler)
