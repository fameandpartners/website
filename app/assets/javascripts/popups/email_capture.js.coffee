# Deprecated in favour of `app/assets/javascripts/partials/email_capture_modal.js.coffee`
# Still used in a couple of landing pages and statics via the
# intermediate shared partial `app/views/shared/_marketing_pop_js.html.slim`
# TODO - DELETE
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
  show: (content, pop_title, opts) ->
    @opts = opts
    @popupLoadRequest(content, pop_title)
      .done(@showModalWindow)
      .fail(@hide)
    

  hide: () ->
    if @opts.onHide 
      @opts.onHide()

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

  popupLoadRequest: (content, pop_title) ->
    loadHtmlUrl = urlWithSitePrefix("/campaigns/email_capture/new?content="+content+"&pop_title="+pop_title)
    $.ajax(
      url: loadHtmlUrl
      type: 'GET'
      dataType: 'html'
    )

  # callbacks
  showModalWindow: (formHtml) ->
    @container.addClass(content+'-popup').fadeIn()
    @container.find('.modal-container .item').addClass('modal-form').html(formHtml)

    @container.find('.modal-container').css({width: opts.width}, 'min-height':'300px').center()    

    if @opts.submit
      @container.find('.modal-container .submitbox').val(@opts.submit) 

    window.onresize = (event) =>
      @container.find('.modal-container').center()      
