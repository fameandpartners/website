# helper methods to track via ga/etc
window.track = {
  pageView: (page_url, page_params) ->
    if _gaq && _gaq.push
      _gaq.push(['_trackPageview', page_url])

  quickView: (page_url) ->
    if _gaq && _gaq.push
      _gaq.push(['_trackPageview', page_url])
}
