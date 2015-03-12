jQuery.fn.center = () ->
  @css("position","absolute")
  @css("top", Math.max(10, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()))
  @css("left", Math.max(10, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()))

jQuery.fn.randomize = () ->
  @each () ->
    $this = $(this)

    $children = _.shuffle($this.children())

    $this.children().remove()
    $this.append($children)


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
    if !_.isUndefined(value) and result.indexOf(value) == -1
      result.unshift(value)
  )
  return result

window.setCurrentPath = (path) ->
  url = "#{ window.location.origin }#{ urlWithSitePrefix(path) }"
  window.history.pushState({ path: url }, '', url)

window.switchToAltImage = (element, no_image_src) ->
  $(element).attr('src', no_image_src).removeAttr('onerror')
  return true

window.initHoverableProductImages = () ->
  $('img[second_image]').each (index, element) ->
    $image = $(element)
    original_image  = $image.attr('original_image')
    second_image    = $image.attr('second_image')

    # provide safe multiple calls on page
    $image.removeAttr('second_image')

    $image.parents('.picture').hover(
      () -> $image.attr('src', second_image),
      () -> $image.attr('src', original_image)
    )

window.scrollScreenTo = (element) ->
  $element = $(element).first()
  return if $element.length == 0
  $('html').animate({ scrollTop: $element.offset().top })

window.buildDelayedRedirectToPage = () ->
  path  = arguments[0] || "/cart?cf=buybtn"
  delay = arguments[1] || 1000

  func = ->
    _.delay ( ->
      window.location.href = urlWithSitePrefix(path)
    ), 1000

window.redirectToLoginAndBack = () ->
  data = { return_to: window.location.href }
  window.location.href = urlWithSitePrefix("/spree_user/sign_in?#{ $.param(data) }")

# extends underscore
# function to remove empty properties from object
# usage: _.compactObject({})
_.mixin(compactObject: (o) ->
  clone = _.clone(o)
  _.each clone, (v, k) ->
    if !v
      delete clone[k]
    return
  clone
)
