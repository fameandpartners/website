window.popups or= {}

window.popups.GirlfriendPop = class GirlfriendPop
  contentLoaded: false

  constructor: () ->
    _.bindAll(@, 'hide', 'show', 'showModalWindow')
    _.bindAll(@, 'closeButtonClickHandler', 'keyPressHandler')
    @container = window.popups.getModalContainer(null, null)
    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)

    $(document).bind 'keyup', @keyPressHandler

  # external api
  show: (version) ->
    @popupLoadRequest(version)
      .done(@showModalWindow)
      .fail(@hide)
    

  hide: () ->
    @container.hide()
    $.cookie('gf_pop', 'hide', { expires: 365, path: '/' })
    console.log('COOKIE: ' + $.cookie('gf_pop', 'hide', { expires: 365, path: '/' }))
    $(document).unbind 'keyup', @keyPressHandler
    @
  
  # handlers
  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()

  keyPressHandler: (e) ->
    @hide() if e.which is 27

  popupLoadRequest: (version) ->
    loadHtmlUrl = urlWithSitePrefix("/campaigns/girlfriend_pop/new?version="+version)
    $.ajax(
      url: loadHtmlUrl
      type: 'GET'
      dataType: 'html'
    )

  # callbacks
  showModalWindow: (formHtml) ->
    @container.addClass('girlfriend-pop').fadeIn()
    @container.find('.modal-container .item').addClass('modal-form').html(formHtml)
    @container.find('.modal-container').css({width: '600px'}).center()