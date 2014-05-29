window.popups or= {}

window.popups.EmailCaptureModalPopup = class EmailCaptureModalPopup
  contentLoaded: false

  constructor: () ->
    _.bindAll(@, 'hide', 'show', 'showModalWindow')
    _.bindAll(@, 'closeButtonClickHandler', 'keyPressHandler')
    @container = window.popups.getModalContainer(null, null)
    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)

    $(document).bind 'keyup', @keyPressHandler

  # external api
  show: (content) ->
    @popupLoadRequest(content)
      .done(@showModalWindow)
      .fail(@hide)
    

  hide: () ->
    @container.hide()
    $.cookie('email_capture', 'hide', { expires: 365, path: '/' })
    $(document).unbind 'keyup', @keyPressHandler
    @
  
  # handlers
  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()

  keyPressHandler: (e) ->
    @hide() if e.which is 27

  popupLoadRequest: (content) ->
    loadHtmlUrl = urlWithSitePrefix("/campaigns/email_capture/new?content="+content)
    $.ajax(
      url: loadHtmlUrl
      type: 'GET'
      dataType: 'html'
    )

  # callbacks
  showModalWindow: (formHtml) ->
    @container.addClass(content+'-popup').fadeIn()
    @container.find('.modal-container .item').addClass('modal-form').html(formHtml)
    @container.find('.modal-container').css({width: '700px'}).center()