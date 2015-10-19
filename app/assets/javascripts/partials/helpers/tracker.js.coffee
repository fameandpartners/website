# helper methods to track via ga/etc
window.track = {
  tracked: []
  dataLayer: window.dataLayer || []

  pageView: (page_url, page_params) ->
    window._gaq or= {}
    if _gaq && _gaq.push
      _gaq.push(['_trackPageview', page_url])

  remarketing_tag: () ->
    conversion_type = 'remarketing_tag'
    return false if _.contains(window.track.tracked, conversion_type)
    id = 979620714
    image = new Image(1,1)
    image.src = "//googleads.g.doubleclick.net/pagead/viewthroughconversion/#{id}/?value=0&guid=ON&script=0"
    window.track.tracked.push(conversion_type)

  conversion: (conversion_type) ->
    return false if _.contains(window.track.tracked, conversion_type)

    params = window.track.getConversionOptions(conversion_type)
    return false if _.isEmpty(params)

    image = new Image(1,1)
    image.src = "//www.googleadservices.com/pagead/conversion/#{params.id}/?value=0&label=#{params.label}&guid=ON&script=0"
    window.track.tracked.push(conversion_type)

  # private
  getConversionOptions: (code) ->
    all = {
      live_chat:  { id: 979620714, label: 'FT_ICN6g1gYQ6qaP0wM' }
      sign_up:    { id: 979620714, label: 'C9flCNah1gYQ6qaP0wM' }
      blog_view:  { id: 979620714, label: '1ddKCM6i1gYQ6qaP0wM' }
      quiz_step1: { id: 979620714, label: 'SYn2CMaj1gYQ6qaP0wM' }
      quiz_step2: { id: 979620714, label: 'I_X_CL6k1gYQ6qaP0wM' }
      ask_friend: { id: 979620714, label: 'g1gICLal1gYQ6qaP0wM' }
      wishlist:   { id: 979620714, label: 'QbWZCK6m1gYQ6qaP0wM' }
      customisation_sign_up: { id: 979620714, label: 'QE93CL7pjwcQ6qaP0wM' }
    }
    return all[code]

  # events
  event: (category, action, label, value) ->
    window._gaq or= {}
    if _gaq && _gaq.push
      eventParams = ['_trackEvent', category, action, null, null]
      eventParams[3] = label if label?
      eventParams[4] = value if value?
      #console.log('tracked', eventParams)
      _gaq.push(eventParams)

  addedToWishlist: (label) ->
    track.event('Wishlist', 'AddedToWishlist', label)

  removedFromWishlist: (label) ->
    track.event('Wishlist', 'RemovedFromWishlist', label)

  addedToCart: (label) ->
    @dataLayer.push({"event": "addToCart"})
    track.event('Products', 'AddedToCart', label)
    track.pageView('/cart/add');

  viewCelebrityInspiration: (label) ->
    track.event('Products', 'ViewCelebrityInspiration', label)

  quizOpened: (label) ->
    track.event('Style Quiz', 'Opened', label)

  quizClickedNext: (label) ->
    track.event('Style Quiz', 'ClickedNext', label)

  quizFinished: (label) ->
    track.event('Style Quiz', 'Finished', label)

  search: (label) ->
    track.event('Searches', 'Searched', label)

  openedSendToFriend: (label) ->
    track.event('SendToFriend', 'Opened', label)

  sentSendToFriend: (label) ->
    track.event('SendToFriend', 'Sent', label)

  customDressClick: (label) ->
    track.event('Products', 'CustomDressClicked', label)

  laybyButtonClick: (label) ->
    track.event('Products', 'LaybyClicked', label)

  twinAlertClick: (label) ->
    track.event('Products', 'TwinAlertClick', label)

  twinAlertOpen: (label) ->
    track.event('Products', 'TwinAlertOpen', label)

  twinAlertRegister: (label) ->
    track.event('Products', 'TwinAlertRegister', label)

  customizationOpened: (label) ->
    track.event('Product Customization', 'Opened', label)

  customizationAddedToCart: (label) ->
    track.event('Product Customization', 'AddedToCart', label)

  inviteToPayOpened: () ->
    track.event('InviteToPay', 'Opened')

  inviteToPaySent: () ->
    track.event('InviteToPay', 'Sent')

  playedSong: (label) ->
    track.event('Product', 'PlaySong', label)

  followedPerfumeLink: (label) ->
    track.event('Product', 'PerfumeClicked', label)

  openedProductInfo: (label) ->
    track.event('Product', 'ProductInfoOpened', label)

  selectedCustomisation: (label) ->
    track.event('Product', 'CustomisatioSelected', label)

  followedStyleProductLink: (label) ->
    track.event('Product', 'StyleItLinkClicked', label)

  clickedBookFreeStylingSession: (label) ->
    track.event('Product', 'BookFreeStylingSessionClicked', label)

  AddPromocodeSuccess: (label) ->
    track.event('AddPromocode', 'Success', label)

  AddPromocodeFailure: (label) ->
    track.event('AddPromocode', 'Failure', label)
}
