window.delegateTo = (object, method_name) ->
  func = () ->
    object[method_name].apply(object, arguments)
  return func

window.setCurrentPath = (path) ->
  url = "#{ window.location.origin }#{ urlWithSitePrefix(path) }"
  window.history.pushState({ path: url }, '', url)

window.scrollScreenTo = (element) ->
  $element = $(element).first()
  return if $element.length == 0
  $('html').animate({ scrollTop: $element.offset().top })