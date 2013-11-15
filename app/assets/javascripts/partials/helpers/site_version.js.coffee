window.getSiteVersionPrefix = () ->
  defaultPrefix = ''
  try
    if window.current_site_version
      code = window.current_site_version.site_version.permalink
      if code && !code.match('us')
        return "/" + code.replace('/', '')
      else
        return defaultPrefix
    else
      return defaultPrefix
  catch exception
    return defaultPrefix

window.urlWithSitePrefix = (url) ->
  prefix = getSiteVersionPrefix()
  cleanedUrl = url.replace(/^\/au/, '').replace(/^\/us/, '')
  return (prefix + cleanedUrl)

originalAjaxMethod = $.ajax

(->
  # Store a reference to the original ajax method.
  originalAjaxMethod = jQuery.ajax
  window.originalAjaxMethod = originalAjaxMethod

  # Define overriding method.
  jQuery.ajax = (url, options) ->
    originalArgs = _.clone(arguments)
    try
      if typeof url is "object"
        options = url
        url = undefined
      options or= {}
      options.url or= url
      
      if options.url
        options.url = urlWithSitePrefix(options.url)

      originalAjaxMethod.call this, options
    catch e
      originalAjaxMethod.apply this, originalArgs
)()

