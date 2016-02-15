# TODO window.urlWithSitePrefix is not used anymore, since we're now detecting site versions using domains
# TODO This file has been flagged as a candidate for deletion, after `urlWithSitePrefix` is completely removed from other places

window.getSiteVersionPrefix = () ->
  defaultPrefix = ''
  try
    if window.app.current_site_version && window.app.current_site_version.url_prefix
      code = window.app.current_site_version.url_prefix
      return "/" + code.replace('/', '')
    else
      return defaultPrefix
  catch exception
    return defaultPrefix

window.urlWithSitePrefix = (url) ->
  return url unless window.app.current_site_version.use_paths?

  prefix = getSiteVersionPrefix()
  cleanedUrl = url.replace(/^\/au\b/, '').replace(/^\/us\b/, '')
  return (prefix + cleanedUrl)
