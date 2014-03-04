window.popups or= {}

window.popups.NewsletterModalPopup = class NewsletterModalPopup
  contentLoaded: false

  constructor: () ->
    _.bindAll(@, 'hide', 'show', 'showModalWindow')
    _.bindAll(@, 'closeButtonClickHandler', 'keyPressHandler')
    @container = window.popups.getModalContainer(null, null)
    @container.on('click', '.close-lightbox, .overlay', @closeButtonClickHandler)

    $(document).bind 'keyup', @keyPressHandler

  # external api
  show: () ->
    @popupLoadRequest()
      .done(@showModalWindow)
      .fail(@hide)

  hide: () ->
    @container.hide()
    $.cookie('newsletter_mp', 'hide', { expires: 365, path: '/' })
    $(document).unbind 'keyup', @keyPressHandler
    @
  
  # handlers
  closeButtonClickHandler: (e) ->
    e.preventDefault()
    @hide()

  keyPressHandler: (e) ->
    @hide() if e.which is 27

  popupLoadRequest: () ->
    loadHtmlUrl = urlWithSitePrefix("/campaigns/newsletter/new")
    $.ajax(
      url: loadHtmlUrl
      type: 'GET'
      dataType: 'html'
    )

  # callbacks
  showModalWindow: (formHtml) ->
    @container.addClass('campaign-newsletter').show()
    @container.find('.modal-container .item').addClass('modal-form').html(formHtml)
    @container.find('.modal-container').css({width: '670px'}).center()

#
#window.popups.newsletterModalPopup = class newsletterModalPopup
#  initialize: (scope) ->
#    @scope = scope
#
#  show: () =>
#    $container = @scope.find('.modal-container')
#    @scope.show()
#
#    @updatePosition()
#
#    @scope.find('.close-lightbox').bind 'click', () =>
#      $.cookie('newsletter_mp', 'hide', { expires: 365, path: '/' })
#      @hide()
#
#    @scope.find('.overlay').bind 'click', @hide
#    $(document).bind 'keyup', @keyPressHandler
#
#  hide: () =>
#    @scope.hide()
#    @scope.find('.close-lightbox').unbind 'click', @hide
#    @scope.find('.overlay').unbind 'click', @hide
#    $(document).unbind 'keyup', @keyPressHandler
#
#  keyPressHandler: (event) =>
#    @hide() if event.which is 27
#
#  updatePosition: () =>
#    @scope.find('.modal-container').center()
