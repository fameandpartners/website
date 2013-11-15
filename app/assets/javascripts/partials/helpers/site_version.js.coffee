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
