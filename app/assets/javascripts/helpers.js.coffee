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

window.switchToAltImage = (image) ->
  $image = $(image)
  $image.removeAttr('onerror')
  if $image.attr('alt_image')
    no_image_src = "/assets/" + $image.attr('alt_image')
    $image.attr('src', no_image_src).removeAttr('onmouseover').removeAttr('onmouseout')
  return true
