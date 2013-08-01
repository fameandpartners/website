jQuery.fn.center = () ->
  @css("position","absolute")
  @css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
                           $(window).scrollTop()) + "px")
  @css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
                            $(window).scrollLeft()) + "px")


window.parseIfString = (obj_or_string) ->
  if typeof obj_or_string == 'string'
    JSON.parse(obj_or_string)
  else
    obj_or_string

window.delegateTo = (object, method_name) ->
  func = () ->
    object[method_name].apply(object, arguments)
  return func

window.getUniqueValues = (array, property) ->
  result = []
  _.each(array, (item) ->
    value = item[property]
    if value and result.indexOf(value) == -1
      result.unshift(value)
  )
  return result

window.setCurrentPath = (path) ->
  url = "#{ window.location.origin }#{ path }"
  window.history.pushState({path:url},'',url)

window.switchToAltImage = (element, no_image_src) ->
  $(element).attr('src', no_image_src).removeAttr('onerror')
  return true

window.initHoverableProductImages = () ->
  $('img[second_image]').each (index, element) ->
    $image = $(element)
    original_image  = $image.attr('src')
    second_image    = $image.attr('second_image')

    # provide safe multiple calls on page
    $image.removeAttr('second_image')

    $image.parents('.thumbnail').hover(
      () -> $image.attr('src', second_image),
      () -> $image.attr('src', original_image)
    )

window.scrollScreenTo = (element) ->
  $element = $(element).first()
  return if $element.length == 0
  $('html').animate({ scrollTop: $element.offset().top })
