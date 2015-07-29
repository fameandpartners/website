window.getSiteVersionPrefix = () ->
  defaultPrefix = ''
  try
    if window.app.current_site_version
      code = window.app.current_site_version.permalink
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
  cleanedUrl = url.replace(/^\/au\b/, '').replace(/^\/us\b/, '')
  return (prefix + cleanedUrl)
